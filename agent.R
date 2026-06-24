library(ellmer)

`%||%` <- \(x, y) if (is.null(x)) y else x
ask <- \(x) isTRUE(utils::askYesNo(x))
arg <- type_string
mktool <- \(f, name, desc, args)
  tool(f, name = name, description = desc, arguments = args)

list_files <- mktool(
  \(path = ".") list.files(path, recursive = TRUE, all.files = TRUE, no.. = TRUE),
  "list_files",
  "List files under a directory.",
  list(path = arg("Directory to list.", required = FALSE))
)

read_file <- mktool(
  \(path) paste(readLines(path, warn = FALSE), collapse = "\n"),
  "read_file",
  "Read a text file.",
  list(path = arg("Path to the text file to read."))
)

write_file <- mktool(
  \(path, text) {
    if (!ask(sprintf("Write %s?", path))) tool_reject()
    writeLines(text, path)
    sprintf("Wrote %s", path)
  },
  "write_file",
  "Write text to a file.",
  list(path = arg("Path to write."), text = arg("Full text content to write."))
)

run_shell <- mktool(
  \(command) {
    if (!ask(sprintf("Run `%s`?", command))) tool_reject()
    out <- suppressWarnings(system2("sh", c("-c", command), stdout = TRUE, stderr = TRUE))
    paste(c(sprintf("exit status: %s", attr(out, "status") %||% 0L), out), collapse = "\n")
  },
  "run_shell",
  "Run a shell command and return its output.",
  list(command = arg("Shell command to run."))
)

chat <- chat_anthropic(
  system_prompt = paste(
    "You are a coding agent running from R. Work in the current directory.",
    "Use tools to inspect files, edit files, and run shell commands."
  )
)

chat$register_tools(list(list_files, read_file, write_file, run_shell))
live_console(chat)

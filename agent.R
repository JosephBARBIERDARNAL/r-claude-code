library(ellmer)

`%||%` <- \(x, y) if (is.null(x)) y else x
ask <- \(x) isTRUE(utils::askYesNo(x))
arg <- type_string

list_files <- tool(
  \(path = ".") list.files(path, recursive = TRUE, all.files = TRUE, no.. = TRUE),
  name = "list_files",
  description = "List files under a directory.",
  arguments = list(path = arg("Directory to list.", required = FALSE))
)

read_file <- tool(
  \(path) paste(readLines(path, warn = FALSE), collapse = "\n"),
  name = "read_file",
  description = "Read a text file.",
  arguments = list(path = arg("Path to the text file to read."))
)

write_file <- tool(
  \(path, text) {
    if (!ask(sprintf("Write %s?", path))) tool_reject()
    writeLines(text, path)
    sprintf("Wrote %s", path)
  },
  name = "write_file",
  description = "Write text to a file.",
  arguments = list(
    path = arg("Path to write."),
    text = arg("Full text content to write.")
  )
)

run_shell <- tool(
  \(command) {
    if (!ask(sprintf("Run `%s`?", command))) tool_reject()
    out <- suppressWarnings(system2("sh", c("-c", command), stdout = TRUE, stderr = TRUE))
    paste(c(sprintf("exit status: %s", attr(out, "status") %||% 0L), out), collapse = "\n")
  },
  name = "run_shell",
  description = "Run a shell command and return its output.",
  arguments = list(command = arg("Shell command to run."))
)

chat <- chat_anthropic(
  system_prompt = paste(
    "You are a coding agent, working in the current directory.",
    "Use tools to inspect/read/edit files and run shell commands."
  )
)

chat$register_tools(list(list_files, read_file, write_file, run_shell))
live_console(chat)

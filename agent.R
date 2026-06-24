library(ellmer)

ask <- function(question) isTRUE(utils::askYesNo(question))

list_files <- tool(
  function(path = ".") {
    list.files(path, recursive = TRUE, all.files = TRUE, no.. = TRUE)
  },
  name = "list_files",
  description = "List files under a directory.",
  arguments = list(
    path = type_string(
      "Directory to list. Defaults to the current directory.",
      required = FALSE
    )
  )
)

read_file <- tool(
  function(path) paste(readLines(path, warn = FALSE), collapse = "\n"),
  name = "read_file",
  description = "Read a text file.",
  arguments = list(path = type_string("Path to the text file to read."))
)

write_file <- tool(
  function(path, text) {
    if (!ask(sprintf("Write %s?", path))) {
      tool_reject()
    }
    writeLines(text, path)
    sprintf("Wrote %s", path)
  },
  name = "write_file",
  description = "Write text to a file, overwriting it if it exists.",
  arguments = list(
    path = type_string("Path to write."),
    text = type_string("Full text content to write.")
  )
)

run_shell <- tool(
  function(command) {
    if (!ask(sprintf("Run `%s`?", command))) {
      tool_reject()
    }
    out <- suppressWarnings(system2(
      "sh",
      c("-c", command),
      stdout = TRUE,
      stderr = TRUE
    ))
    status <- attr(out, "status")
    if (is.null(status)) {
      status <- 0L
    }
    paste(c(sprintf("exit status: %s", status), out), collapse = "\n")
  },
  name = "run_shell",
  description = "Run a shell command and return its combined output.",
  arguments = list(
    command = type_string(
      "Shell command to run from the current working directory."
    )
  )
)

main <- function() {
  chat <- chat_anthropic(
    system_prompt = paste(
      "You are a coding agent running from R.",
      "Work in the current directory.",
      "Use tools to inspect files, edit files, and run shell commands.",
    )
  )

  chat$register_tools(list(list_files, read_file, write_file, run_shell))
  live_console(chat)
}

if (sys.nframe() == 0) {
  main()
}

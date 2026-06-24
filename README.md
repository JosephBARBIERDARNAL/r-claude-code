# r-claude-code

A tiny Claude Code-like coding agent written in R with
[ellmer](https://ellmer.tidyverse.org/).

The whole demo lives in `agent.R`: it creates an Anthropic chat, registers a
few local tools, and starts `ellmer::live_console()`.

## Run

Add your Anthropic credentials in `.Rprofile`, then run:

```sh
Rscript agent.R
```

Try prompts like:

```text
List the files in this repo.
Read README.md.
Create a hello.txt file.
Run ls -la.
```

The agent asks before writing files or running shell commands.

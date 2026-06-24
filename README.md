# R Claude Code

```R
> main()

Using model = "claude-sonnet-4-5-20250929".
╔═══════════════════════════════╗
║ Entering chat console.        ║
║ Use """ for multi-line input. ║
║ Type 'Q' to quit.             ║
╚═══════════════════════════════╝
>>> add colors to the output of the console in agent.R

I'll help you add colors to the console output in agent.R. Let me first examine the file to see what we're working with.
◯ [tool call] read_file(path = "agent.R")
● #> library(ellmer)
  #>
  #> ask <- function(question) {
  #>  isTRUE(utils::askYesNo(question))
  #> }
  #> …
Now I'll add colors to the console output. I'll use the `crayon` package which is a popular R package for adding colors to console output. Let me update the
.................................
```

After reading [Hadley's newsletter](https://substack.com/home/post/p-200800827) (highly recommend!) about what agents are, I started wondering how easy it would be to create a Claude Code-like app entirely in R using [`ellmer`](https://ellmer.tidyverse.org/).

The whole demo lives in `agent.R`. You only need a valid `ANTHROPIC_API_KEY` environment variable and can then run `agent.R` interactively in R. It turns out that you only need about ~50 lines of code to get something that behaves like Claude Code.

It's definitely much less capable and isn't meant to be used as-is, but it's interesting to see that these kinds of tools are **not necessarily complicated** once you **take the time to understand how they work**.

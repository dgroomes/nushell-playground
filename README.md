# nushell-playground

📚 Learning and exploring Nushell.


## Overview

I will forever use Bash (hyperbole), but I want more power, feasible extensibility and better ergonomics. I've had my eye on Nushell
for a few years, and it is rich with features at this point. This repository is for me to learn Nushell.


## Instructions

Follow these instructions to run some scripts and experiment with Nushell.

1. Pre-requisite: Nushell
   * I built it from source. I'm using 0.92.2.
2. Start a Nushell session.
   * ```shell
     nu
     ```
3. Import all exposed definitions from the `bookmark-launcher.nu` file.
   * ```shell
     use bookmark-launcher.nu *
     ```
4. Try out a command and get a feel for completions
   * Type `launch-b` and then press `Tab`. The full `launch-bookmark` command will appear.
   * Try `Tab` again and you will see `reference` and `fun` as suggestions. The `reference` suggestion is highlighted already.
   * Press `Tab` once more to cycle to the `fun` suggestion.
   * Press `Enter` to select `fun`. The `fun` string will be added to the command line.
   * Press `Space` and then `Tab` to see the completions related to `fun`. They are `youtube` and `twitter.com`.
   * Press `Enter` to select `youtube`.
   * You'll get a message like the following:
     ```
     You chose fun today. Launching https://youtube.com ...
     ```
5. Try the `lb` alias
   * Aliases are an important way to compress your commandline workflow, especially for frequently used commands. Type `lb`
     and follow in the same steps as above but launch something else.
   * Study the `bookmark-launcher.nu` file, hack on it, and add your own bookmarks.
   * Next, let's try a custom completer
6. Exit the current Nushell session with `exit`
7. Start a new Nushell session and load our config for a custom completer
   * ```shell
     nu --env-config completer.nu --config ""
     ```
8. Type out the sample command and try out the auto-completion
   * Type our `describe-color ` (including the space) and then press `Tab`. You should see the completion options like
     the following.
   * ```text
     blue
     red
     green
     ```


## Wish List

General clean-ups, TODOs and things I wish to implement for this project

* [ ] Consider writing a plugin. Can I write a Nushell plugin in the Nu language itself?
* [x] DONE Make the auto-completion example my own.
* [x] DONE (Answer: use the right arrow key) Figure out the auto-completion UX. I'm getting a bit confused about when/why it auto-completes from historical
  commands and how to choose that completion. If I press enter of course that just runs the text I've typed so far and if
  press tab it just cycles through normal completions not the historical suggestion.
* [ ] What are the debugging and maybe other meta features of Nushell? Are there bells and whistles with regard to
  logging or maybe some statistics?
* [x] DONE (`use ~/repos/opensource/nu_scripts/custom-completions/git/git-completions.nu *`) Load Nushell-maintained completions from ["nu_scripts"](https://github.com/nushell/nu_scripts/tree/4eab7ea772f0a288c99a79947dd332efc1884315/custom-completions)
* [x] Custom completer.
* [ ] Fallback to Bash for completions. While Carapace and Fish are interesting, I've already mastered Bash completions.
  Also see [this person's experience with Carapace and their decision to use the Fish completer in Nushell](https://news.ycombinator.com/item?id=40131630).
* [ ] How should I time nu startup? Does it have anything built-in to measure anything? It would be easy to just handwrite
  the couple lines but curious if there is something more interesting that I'm missing.
* [ ] When I do `cp $nu.config-path ~/some-directo` and as I'm trying to autocomplete the directory name, I don't get
  completions, I just get `NO RECORDS FOUND`. But in some other contexts with `cp` I do get completion. What's going on?
  I have read that the fallback to file completions doesn't work in some cases.
* [x] DONE How do errors work? I know there is a try/catch, but I want a feel for it.
  * <https://www.nushell.sh/book/stdout_stderr_exit_codes.html#using-the-complete-command>
  * What's the idiomatic way to throw a low-noise error? I don't always want the line of source thing. I just want red
    text and a message. Solution: use `--unspanned`.
  * Error handling behavior for external commands is a bit of a gotcha and will likely change, but I think it's
    complicated so probably not soon. See <https://github.com/nushell/nushell/issues/10633>. I think I'm going to use
    `| complete` a lot, which will be more robust but isn't really in the spirit of shell scripting. 


## Reference

* [Nushell](https://www.nushell.sh)

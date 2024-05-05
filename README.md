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


## Wish List

General clean-ups, TODOs and things I wish to implement for this project

* [ ] Consider writing a plugin. Can I write a Nushell plugin in the Nu language itself?
* [x] DONE Make the auto-completion example my own.
* [x] DONE (Answer: use the right arrow key) Figure out the auto-completion UX. I'm getting a bit confused about when/why it auto-completes from historical
  commands and how to choose that completion. If I press enter of course that just runs the text I've typed so far and if
  press tab it just cycles through normal completions not the historical suggestion.
* [ ] What are the debugging and maybe other meta features of Nushell? Are there bells and whistles with regard to
  logging or maybe some statistics? 
* [ ] What is the culture around completions for third-party commands? Does the Nushell community just have to implement
  them by hand, for things like `git`, etc.? Is there some Bash completion compatibility trick?


## Reference

* [Nushell](https://www.nushell.sh)

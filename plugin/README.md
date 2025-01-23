# plugin

My example Nushell plugin.


## Instructions

Follow these instructions to build and run the plugin.

1. Build the plugin
   * ```nushell
     cargo build
     ```
2. Remove the old plugin (if it exists)
   * ```nushell
     plugin rm my
     ```
3. Install the plugin
   * ```nushell
     plugin add target/debug/nu_plugin_my
     ```
   * You should see the plugin appear as 'added' when you run the following command.
   * ```nushell
     plugin list
     ```
4. Load the plugin
   * ```nushell
     plugin use my
     ```
   * This is an important step. I'm surprised an installed plugin isn't activated by default.
5. Try it out
   * ```nushell
     my -h
     ```
   * ```nushell
     my hello
     ```


## Wish List

General clean-ups, TODOs and things I wish to implement for this project:

* [x] DONE Scaffold
* [x] DONE Get a working command.
* [ ] Do something much more interesting and maybe meld the README into the root README
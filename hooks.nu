# Let's explore hooks.
#
# See https://www.nushell.sh/book/hooks.html

# Let's start simple. Say 'Hi' every time the prompt is displayed.
export def --env register-say-hi-hook [] {
    $env.config = ($env.config | upsert hooks.pre_prompt {
        default [] | append { print "Hi" }
    })
}

# A common use-case for hooks is to track commands that are run (e.g. for shell history), and we implement that with a
# `pre_execution` hook. Let's define a hook that adds the command string to a list in an environment variable.
export def --env register-command-history-hook [] {
    $env.config = ($env.config | upsert hooks.pre_execution {
        default [] | append {
            let cmd = (commandline)
            print $"Adding command to MY_COMMAND_HISTORY: '($cmd)'"
            $env.MY_COMMAND_HISTORY = ($env.MY_COMMAND_HISTORY? | append $cmd)
        }
    })
}

# Interestingly, hooks allow registering 'Nu code as a string'. I think this is designed to work around the constraints of the
# parse-evaluate execution model of Nushell. Please read the excellent explanation of how Nushell executes code: https://www.nushell.sh/book/how_nushell_code_gets_run.html
#
# Let's explore a use-case that the parse-evaluate model makes difficult: "sourcing a dynamic path". This use-case is
# described by the Nushell docs: https://www.nushell.sh/book/how_nushell_code_gets_run.html#implications
#
# This use-case can not be implemented in a Nushell script (headless). But I think it can be simulated in a Nushell REPL
# (interactive). Let's see...
#
# Can we write a command, that registers a circuitous system of lifecycle interactions, that actually let's us source
# a path that we haven't hardcoded? In this sense, the path of the source is dynamic.
#
# Ok, imagine we are a software developer in a Nushell REPL session, and we're in the directory of one of our projects
# like "my-web-service/". By convention, our software projects have the files "build-commands.nu" and
# "deployment-commands.nu". Because this a common pattern for us, we want a convenient command like "dev-mode" that
# sources (or 'overlay') both these files and gets us ready to work on our project.
#
# Consider if we defined the "dev-mode" command like this in our 'config.nu':
#
#     export def --env dev-mode [] {
#         source "build-commands.nu"
#         source "deployment-commands.nu"
#     }
#
# When Nushell starts up in interactive mode, it would fail to parse this command with 'File not found: build-commands.nu'.
# This is the crux of our problem. Let's try to work around this by a 'self-erasing hook' pattern that gives us the user
# experience of dynamic path sourcing.

# This command is close but doesn't quite work. The hook function actually does drop items from the pre_prompt list, but
# somehow the hook still runs even when its whittled down to 0 hooks. Even in your REPL, if you run '$env.config.hooks.pre_prompt | length'
# you will see it go to 0 (I start with 2 maybe because of starship, I'm not even sure), but the print statements still
# run.
export def --env register-self-erasing-hook-leaves-phantom-hook [] {
    print $"[register-self-erasing-hook] There are ($env.config.hooks.pre_prompt | length) pre_prompt hooks."
    print $"[register-self-erasing-hook] Registering a hook."
    $env.config = ($env.config | upsert hooks.pre_prompt {
        default [] | append {
            print $"[self-erasing-hook] There are ($env.config.hooks.pre_prompt | length) pre_prompt hooks."
            print "[self-erasing-hook] Removing self."
            $env.config = ($env.config | upsert hooks.pre_prompt { drop })
            print $"[self-erasing-hook] There are ($env.config.hooks.pre_prompt | length) pre_prompt hooks."
        }
    })
    print $"[register-self-erasing-hook] Done registering. There are ($env.config.hooks.pre_prompt | length) pre_prompt hooks."
}

# For some reason, we have better luck with the 'command as string' hook approach. This successfully self-erases! I'm
# not exactly sure why, but it probably has to do with scoping, symbol resolution, reference cleanup.
export def --env register-self-erasing-hook-works [] {
    print $"[register-self-erasing-hook] There are ($env.config.hooks.pre_prompt | length) pre_prompt hooks."
    print $"[register-self-erasing-hook] Registering a hook."
    $env.config = ($env.config | upsert hooks.pre_prompt {

        # Notice how the hook function is defined with a raw string.
        default [] | append r#'
print $"[self-erasing-hook] There are ($env.config.hooks.pre_prompt | length) pre_prompt hooks."
print "[self-erasing-hook] Removing self."
$env.config = ($env.config | upsert hooks.pre_prompt { drop })
print $"[self-erasing-hook] There are ($env.config.hooks.pre_prompt | length) pre_prompt hooks."
'#
    })
    print $"[register-self-erasing-hook] Done registering. There are ($env.config.hooks.pre_prompt | length) pre_prompt hooks."
}

# Let's put it all together. Instead of the 'dev-mode' command, we'll define an 'overlay-all' command that overlays all
# Nu files in the current directory (e.g. 'bookmark-launcher.nu', 'completer.nu', 'hooks.nu', etc.).
export def --env overlay-all [] {
    # I don't want to stifle creativity, but I need some constraints to make this practical. Let's only allow '.nu'
    # files with letters, numbers, hyphens, and underscores in their names.
    let nu_files = ls *.nu | get name | where $it =~ '(?i)^[a-z0-9_-]+\.nu$'

    # Create a Nu code snippet that overlays all these files and deletes itself. For example, a snippet would look like:
    #
    #    # ERASE ME
    #    overlay use bookmark-launcher.nu
    #    overlay use completer.nu
    #    overlay use hooks.nu
    #    $env.config = ($env.config | upsert hooks.pre_prompt { where $it != "# ERASE ME" })
    #
    let overlay_lines = $nu_files | each { $"overlay use ($in)" }
    const ERASE_SNIPPET = '$env.config = ($env.config | upsert hooks.pre_prompt { where $it != "# ERASE ME" })'
    let snippet = ["# ERASE ME" ...$overlay_lines $ERASE_SNIPPET] | str join (char newline)

    print $snippet

    $env.config = ($env.config | upsert hooks.pre_prompt {
        default [] | append $snippet
    })
}

#!/usr/bin/env nu

const DIR = path self | path dirname

export def main [] {
    print "Hello from Nushell! I am the 'main' command in 'hello.nu'."

    print $"There are (ls | length) files in the current directory."

    cd $DIR
    print $"There are (ls | length) files in the directory containing this script."

    cd ~
    print $"There are (ls | length) files in the home directory."
}

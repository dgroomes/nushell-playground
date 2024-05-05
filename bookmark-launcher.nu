# This module defines a 'launch-bookmark' command for launching bookmarked pages in the browser.
#
# This is a way for me to learn the basics of Nushell and the Nu language.


# A hardcoded collection of bookmarks. This is a dictionary of dictionaries. In the Nu language, dictionaries are called
# "records".
#
# The top-level entries ("reference", "fun") are categories of bookmarks. Within each category are key-value pairs of
# bookmark names and their URLs.
const bookmarks = {
    "reference": {
        "wikipedia": "https://en.wikipedia.org/wiki/Main_Page",
        "github": "https://github.com/dgroomes",
        "nushell": "https://www.nushell.sh"
    },
    "fun": {
        "youtube": "https://youtube.com",
        "twitter": "https://twitter.com"
    }
}


# A command that returns the categories of bookmarks.
#
# Note that Nu typically calls functions "commands" because it is a shell language and should bias towards the domain of
# the commandline.
def categories [] {
    $bookmarks | transpose keys | get keys
}


def bookmarks [context: string] {
   # Because 'bookmarks' is referenced with '@' in a type parameter from the 'launch-bookmark' command, Nu
   # passes the full command string to 'bookmarks'. Let's call this 'context'. The context will equal something like:
   #
   #  "launch-bookmark reference"
   #  "launch-bookmark fun"
   #  "launch-bookmark something-typed-in-manually-by-the-user"
   #
   # We want to take the last word of the context and use it to look up the bookmark names.
   #
   # I don't really understand what happens in the "something-typed-in-manually-by-the-user" case. It should error. I
   # imagine Nushell is just catching the error and showing "NO RECORDS FOUND" on the commandline.
   let category = $context | split words | last
   $bookmarks | get $category | transpose keys | get keys
}

# This command launches a bookmarked webpage in the browser. The useful feature of this command is that it auto-completes
# bookmark categories (e.g. "reference", "fun") and bookmark names (e.g. "wikipedia", "github", "nushell") so that you
# can easily discover/remember your bookmarks and save the effort of typing them out in full.
#
# This function builds on the previous ones. Notice that it is exported while the others are not. This is a nice way to
# encapsulate implementation details from the calling environment.
#
# This is inspired from the official example in the docs: https://www.nushell.sh/book/custom_completions.html#context-aware-custom-completions
export def launch-bookmark [
    category: string@categories
    bookmark: string@bookmarks
] {
    let url = $bookmarks | get $category | get $bookmark
    print $"You chose ($category) today. Launching ($url) ..."
    start $url
}

# Alias the 'launch-bookmark' command to something shorter
export alias lb = launch-bookmark

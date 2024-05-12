# A simple command that we will use to exercise a custom completer. Normally, we can express completions on a Nu command
# by using "@" on the parameter type and referencing another command. But we'll omit that and instead use a custom
# completer.
export def describe-color [color: string] {
    match $color {
         blue => "A calm color"
         red => "A passionate color"
         green => "A natural color"
         _ => "I don't know that color"
    } | print $in
}

let custom_completer_colors =  { |spans|
  if ($spans.0 == "describe-color") {
    [
        { value: "blue" description: "" },
        { value: "red" description: "" },
        { value: "green" description: "" }
    ]
  }
}

$env.config.completions.external = {
  enable: true
  completer: $custom_completer_colors
}

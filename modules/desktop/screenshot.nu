#!/usr/bin/env nu

def main [ --snip ] {
  let file = $"~/Pictures/(date now | date format %Y-%m-%d_%H:%M:%S).png"
  if $snip {
    slurp -d | grim -g - $file
  } else {
    grim $file
  }
  notify-send -u low -t 5000 -i $file $"Screenshot saved to ($file)"
}

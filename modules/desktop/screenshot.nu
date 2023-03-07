#!/usr/bin/env nu

# SPDX-FileCopyrightText: 2023 Sam Nystrom <sam@samnystrom.dev>
# SPDX-License-Identifier: CC0-1.0

def main [ --snip ] {
  let file = $"~/Pictures/(date now | date format %Y-%m-%d_%H:%M:%S).png"
  if $snip {
    slurp -d | grim -g - $file
  } else {
    grim $file
  }
  notify-send -u low -t 5000 -i $file $"Screenshot saved to ($file)"
}

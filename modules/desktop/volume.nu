#!/usr/bin/env nu

# SPDX-FileCopyrightText: 2023 Sam Nystrom <sam@samnystrom.dev>
# SPDX-License-Identifier: CC0-1.0

def main [] {
  exit 1
}

def 'main up' [] {
  let volume = (pactl get-sink-volume @DEFAULT_SINK@
    | parse -r '(?P<volume>\d+)%'
    | get volume
    | each { into int }
    | math max)

  if $volume <= 95 {
    pactl set-sink-volume @DEFAULT_SINK@ +5%
  } else {
    pactl set-sink-volume @DEFAULT_SINK@ 100%
  }
}

def 'main down' [] {
  pactl set-sink-volume @DEFAULT_SINK@ -5%
}

def 'main mute' [] {
  pactl set-sink-mute @DEFAULT_SINK@ toggle
}

def 'main mic-mute' [] {
  pactl set-source-mute @DEFAULT_SINK@ toggle
}

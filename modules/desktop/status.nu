#!/usr/bin/env nu

# SPDX-FileCopyrightText: 2023 Sam Nystrom <sam@samnystrom.dev>
# SPDX-License-Identifier: CC0-1.0

def pulseaudio [] {
  let volume = (pactl get-sink-volume @DEFAULT_SINK@
    | parse -r '(?P<volume>\d+)%'
    | get volume
    | math max
    | into int)
  let volume_symbol = if $volume == 0 {
    ""
  } else if $volume <= 50 {
    ""
  } else {
    ""
  }
  echo $"<span foreground=\"#ed8796\">($volume_symbol) ($volume)%</span>"
}

def network [] {
  let ssid = (iwgetid -r)
  let text = if $ssid == null {
    "直 $ssid"
  } else {
    "睊 "
  }
  echo $"<span foreground=\"#f5a97f\">($text)</span>"
}

def brightness [] {
  echo $"<span foreground=\"#eed49f\"> (brightnessctl -m | awk -F, '{ print $4 }')</span>"
}

def battery [] {
  let status = (cat /sys/class/power_supply/BAT0/status)
  let capacity = (cat /sys/class/power_supply/BAT0/capacity | into int)

  let idx = ($capacity - 1) / 10
  let symbol = ({
    "Discharging": { ["<span foreground=\"#ed8796\">󰂃</span>" "" "" "" "" "" "" "" "" ""] | get $idx },
    "Charging": { ["" "" "" "" "" "" "" "" "" ""] | get $idx },
    "Full": { "" },
  } | get $status | do $in)
  echo $"<span foreground=\"#a6da95\">($symbol) ($capacity)%</span>"
}

def clock [] {
  $"<span foreground=\"#7dc4e4\"> (date now | date format '%b %d %H:%M')</span>"
}

loop {
  somebar -c $"status (pulseaudio) | (network) | (brightness) | (battery) | (clock)"
  sleep 200ms
}

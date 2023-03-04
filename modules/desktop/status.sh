#!/bin/sh

set -eu

pulseaudio() {
  volume=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+(?=%)' | head -1)
  if [ "$volume" -eq 0 ]; then
    volume_symbol=""
  elif [ "$volume" -le 50 ]; then
    volume_symbol=""
  else
    volume_symbol=""
  fi
  echo "$volume_symbol $volume%"
}

network() {
  ssid=$(iwgetid -r)
  if [ -n "$ssid" ]; then
    echo "直 $ssid"
  else
    echo "睊"
  fi
}

brightness() {
  echo " $(brightnessctl -m | awk -F, '{ print $4 }')"
}

battery() {
  status=$(cat /sys/class/power_supply/BAT0/status)
  capacity=$(cat /sys/class/power_supply/BAT0/capacity)

  case "$status" in
    "Discharging") symbols="         " ;;
    "Charging") symbols="         " ;;
  esac
  idx=$(((capacity + 5) / 10 + 1))
  symbol=$(echo "$symbols" | awk "{ print \$$idx }")

  echo "$symbol $capacity%"
}

clock() {
  echo " $(date '+%b %d %H:%M')"
}

while true; do
  somebar -c "status $(pulseaudio) | $(network) | $(brightness) | $(battery) | $(clock)"
  sleep 0.5
done

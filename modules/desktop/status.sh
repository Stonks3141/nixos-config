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
  echo "<span foreground=\"#ed8796\">$volume_symbol $volume%</span>"
}

network() {
  ssid=$(iwgetid -r)
  if [ -n "$ssid" ]; then
    echo "<span foreground=\"#f5a97f\">直 $ssid</span>"
  else
    echo "<span foreground=\"#f5a97f\">睊</span>"
  fi
}

brightness() {
  echo "<span foreground=\"#eed49f\"> $(brightnessctl -m | awk -F, '{ print $4 }')</span>"
}

battery() {
  status=$(cat /sys/class/power_supply/BAT0/status)
  capacity=$(cat /sys/class/power_supply/BAT0/capacity)
  idx=$((capacity / 10 + 1))
  symbol=
  case "$status" in
    "Discharging") symbol=$(echo "         " | awk "{ print \$$idx }" ) ;;
    "Charging"   ) symbol=$(echo "         " | awk "{ print \$$idx }" ) ;;
    "Full"       ) symbol="" ;;
  esac
  echo "<span foreground=\"#a6da95\">$symbol $capacity%</span>"
}

clock() {
  echo "<span foreground=\"#7dc4e4\"> $(date '+%b %d %H:%M')</span>"
}

while true; do
  somebar -c "status $(pulseaudio) | $(network) | $(brightness) | $(battery) | $(clock)"
  sleep 0.2
done

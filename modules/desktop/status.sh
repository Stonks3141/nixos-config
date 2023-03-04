#!/bin/sh

set -eu

notifications() {
  echo ""
  # tiramisu stuff
}

pulseaudio() {
  volume=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+(?=%)' | head -1)
  if [ "$volume" -eq 0 ]; then
    volume_symbol=""
  elif [ "$volume" -le 50 ]; then
    volume_symbol=""
  else
    volume_symbol=""
  fi
  echo "$volume_symbol $volume%%"
}

network() {
  echo "hi"
}

brightness() {
  echo "  $(brightnessctl -m | awk -F, '{ print $4 }')"
}

clock() {
  echo " $(date '+%b %d %H:%M')"
}

while true; do
  echo "status $(notifications) | $(pulseaudio) | $(network) | $(brightness) | $(clock)" \
    > "$XDG_RUNTIME_DIR/somebar-1"
  sleep 0.2
done

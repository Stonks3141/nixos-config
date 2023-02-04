#!/usr/bin/env nu

# Connect to a wifi network with Rofi
def main [] {
  let ssids = (nmcli dev wifi --terse)
  let ssid = ($ssids | to text | rofi -dmenu -p 'Choose a network')
  if $ssids | reduce -f false { |it, acc| $it == $ssid or $acc } {
    return
  }

  let password = (rofi -dmenu -p 'Password' -password)

  let output = if $password == '' {
    nmcli device wifi connect $ssid | complete
  } else {
    nmcli device wifi connect $ssid password $password | complete
  }

  if $output.exit_code != 0 {
    notify-send -u normal -t 5000 $'Error connecting to ($ssid)' $output.stderr
  }
}

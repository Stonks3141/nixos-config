#!/usr/bin/env nu

# A Rofi script for the power button
def main [choice?: string] {
  if ($choice == null) {
    ['Log Out' 'Power Off' 'Restart'] | to text
  } else {
    {
      'Log Out': {swaymsg exit}
      'Power Off': {systemctl shutdown}
      'Restart': {systemctl reboot}
    } | get $choice | do $in
  }
}

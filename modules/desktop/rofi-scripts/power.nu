#!/usr/bin/env nu

# A Rofi script for the power button
def main [choice?: string] {
  if ($choice == null) {
    ['Log Out' 'Power Off' 'Restart'] | to text
  } else {
    {
      'Log Out': {hyprctl dispatch exit}
      'Power Off': {systemctl poweroff}
      'Restart': {systemctl reboot}
    } | get $choice | do $in
  }
}

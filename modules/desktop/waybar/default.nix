{ pkgs, ... }:
let
  power = pkgs.writeScript "power.nu" (builtins.readFile ../rofi-scripts/power.nu);
  wifi = pkgs.writeScript "wifi.nu" (builtins.readFile ../rofi-scripts/wifi.nu);
in
{
  home-manager.users.samn = { ... }: {
    programs.waybar = {
      enable = true;
      settings.mainBar = {
        layer = "top";
        position = "top";
        height = 40;
        output = [ "eDP-1" "HDMI-A-1" ];
        modules-left = [ "custom/nix" "wlr/workspaces" "sway/mode" ];
        modules-center = [ ];
        modules-right = [ "pulseaudio" "network" "backlight" "battery" "clock" "custom/power" ];

        "custom/nix" = {
          format = " ";
        };

        "custom/power" = {
          format = " ";
          on-click = "${pkgs.rofi}/bin/rofi -show power -modes power:${power}";
        };

        clock = {
          format = " {:%H:%M}";
          tooltip = false;
        };

        battery = {
          interval = 15;
          format = "{icon} {capacity}%";
          format-icons = {
            full = "";
            discharging = [ "" "" "" "" "" "" "" "" "" "" ];
            # TODO: Add missing icons (github:ryanoasis/nerd-fonts#279).
            charging = [ " " " " " " " " " " " " " " " " " " " " ];
          };
          tooltip = false;
        };

        backlight = {
          format = " {percent}%";
        };

        network = {
          format-disconnected = "睊";
          format-ethernet = " {ifname}";
          format-wifi = "直 {signalStrength}%";
          tooltip-format-wifi = "{essid}";
          on-click = wifi;
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-bluetooth = "{icon} {volume}%";
          format-muted = "";
          format-icons = {
            headphone = "";
            headset = "";
            default = [ "" "" ];
          };
          tooltip = false;
        };
      };
      style = ./waybar.css;
    };
  };
}

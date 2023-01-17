{ pkgs, ... }:
let
  powerScript = pkgs.writeScript "power.nu" (builtins.readFile ./power.nu);
in
{
  home-manager.users.samn = { ... }: {
    programs.waybar = {
      enable = true;
      settings.mainBar = {
        layer = "bottom";
        position = "top";
        height = 40;
        output = [ "eDP-1" "HDMI-A-1" ];
        modules-left = [ "custom/nix" "sway/workspaces" "sway/mode" ];
        modules-center = [ ];
        modules-right = [ "pulseaudio" "network" "backlight" "battery" "clock" "custom/power" ];

        "custom/nix" = {
          format = " ";
        };

        "custom/power" = {
          format = " ";
          on-click = "${pkgs.rofi}/bin/rofi -show power -modes power:${powerScript}";
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
            # TODO: Add missing icons if nerd fonts ever get their shit together (nerd-fonts#279).
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

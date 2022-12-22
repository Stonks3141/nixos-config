{ ... }: {
  home-manager.users.samn = { ... }: {
    programs.waybar = {
      enable = true;
      settings.mainBar = {
        layer = "bottom";
        position = "top";
        height = 40;
        output = [ "eDP-1" ];
        modules-left = [ "sway/workspaces" "sway/mode" ];
        modules-center = [ ];
        modules-right = [ "pulseaudio" "network" "battery" "clock" ];

        clock.tooltip = false;

        battery = {
          interval = 15;
          format = "{capacity}% {icon}";
          format-icons = {
            full = "";
            discharging = [ "" "" "" "" "" "" "" "" "" "" ];
            # TODO: Add missing icons if nerd fonts ever get their shit together (nerd-fonts#279).
            charging = [ " " " " " " " " " " " " " " " " " " " " ];
          };
          tooltip = false;
        };

        network = {
          format-disconnected = "睊 ";
          format-ethernet = "{ifname}  ";
          format-wifi = "{essid} ({signalStrength}%) 直 ";
          tooltip = false;
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

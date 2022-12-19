{ config, lib, pkgs, ... }: {
  config = let
    bgImage = config.samn.desktop.bgImage;
    baseColor = config.samn.desktop.baseColor;
    accentColor = config.samn.desktop.accentColor;
    gtkTheme = config.samn.desktop.gtkTheme;
  in
  {
    home-manager.users.samn = {
      wayland.windowManager.sway = {
        enable = true;
        wrapperFeatures.gtk = true;
        
        config = rec {
          modifier = "Mod4";
          gaps.inner = 10;
          window.border = 2;
          colors = {
            focused = {
              background = "#285577";
              border = "#${accentColor}";
              childBorder = "#${accentColor}";
              indicator = "#${accentColor}";
              text = "#ffffff";
            };
            unfocused = {
              background = "#222222";
              border = "#${baseColor}";
              childBorder = "#${baseColor}";
              indicator = "#292d2e";
              text = "#888888";
            };
          };
          terminal = "kitty";
          focus.followMouse = false;
          startup = [
            { command = "${pkgs.swayidle}/bin/swayidle -w timeout 300 '${pkgs.swaylock}/bin/swaylock -f -i ${bgImage}' timeout 150 '${pkgs.sway}/bin/swaymsg \"output * dpms off\"' resume '${pkgs.sway}/bin/swaymsg \"output * dpms on\"' before-sleep '${pkgs.swaylock}/bin/swaylock -f -i ${bgImage}'"; }
          ];
          menu = "rofi -show run";
          bars = [
            { command = "waybar"; }
          ];
          input = {
            "1:1:AT_Translated_Set_2_keyboard" = {
              repeat_rate = "40";
              repeat_delay = "300";
            };
            "1133:16500:Logitech_G305" = {
              left_handed = "enabled";
            };
          };
          output = {
            "eDP-1" = { bg = "${bgImage} stretch"; };
          };
          keybindings = lib.mkOptionDefault {
            # Exit
            "${modifier}+Shift+e" = ''
              exec swaynag -t warning -m 'What do you want to do?' \
                -b 'Shut Down' 'systemctl poweroff' \
                -b 'Reboot' 'systemctl reboot' \
                -b 'Log Out' 'swaymsg exit'
            '';
            # Screenshot
            "${modifier}+Print" = ''
              exec ${pkgs.slurp}/bin/slurp -d | ${pkgs.grim}/bin/grim -g - ~/Pictures/`date +%Y-%m-%d_%H:%M:%S`.png && \
              notify-send -u low -t 5000 -i ~/Pictures/`date +%Y-%m-%d_%H:%M:%S`.png "Screenshot saved to ~/Pictures/`date +%Y-%m-%d_%H:%M:%S`.png"
            '';
            Print = ''
              exec ${pkgs.grim}/bin/grim ~/Pictures/`date +%Y-%m-%d_%H:%M:%S`.png && \
              notify-send -u low -t 5000 -i ~/Pictures/`date +%Y-%m-%d_%H:%M:%S`.png "Screenshot saved to ~/Pictures/`date +%Y-%m-%d_%H:%M:%S`.png"
            '';
            # Volume
            XF86AudioRaiseVolume = ''
              exec [ $(${pkgs.pulseaudio}/bin/pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+(?=%)' | head -1) -le 95 ] \
                && ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5% \
                || ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ 100%
            '';
            XF86AudioLowerVolume = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%";
            XF86AudioMute = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
            XF86AudioMicMute = "exec ${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle";
            # Brightness
            XF86MonBrightnessDown = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 5%-";
            XF86MonBrightnessUp = "exec ${pkgs.brightnessctl}/bin/brightnessctl set +5%";
          };
        };
        
        extraConfig = ''
          exec dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
          exec systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
          exec systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
          exec mako
        '';

        swaynag = {
          enable = true;
          settings = {
            warning = {
              background = baseColor;
              button-background = "494d64";
              border-bottom = accentColor;
              button-border-size = 0;
              button-margin-right = 5;
              button-padding = 5;
              text = "ffffff";
              button-text = "ffffff";
            };
          };
        };
      };
    };

    environment.systemPackages = with pkgs; [
      greetd.gtkgreet
    ];

    services.greetd = let
      swayConfig = pkgs.writeTextFile {
        name = "sway-config";
        text = ''
          include ${pkgs.sway}/etc/sway/config
          exec dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
          exec ${pkgs.greetd.gtkgreet}/bin/gtkgreet -l -c ${pkgs.sway}/bin/sway -s ${gtkTheme.package}/share/themes/${gtkTheme.name}/gtk-3.0/gtk-dark.css; swaymsg exit
        '';
      };
    in
    {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.sway}/bin/sway --config ${swayConfig}";
        };
      };
    };
  };
}

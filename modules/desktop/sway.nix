{ config, lib, pkgs, ... }:
let
  bgImage = config.samn.desktop.bgImage;
  gtkTheme = config.samn.desktop.gtkTheme;
  baseColor = "24273a";
  accentColor = "ed8796";
  screenshot = pkgs.writeScript "screenshot" (builtins.readFile ./screenshot.nu);
in
{
  home-manager.users.samn = { pkgs, ... }: {
    home.packages = with pkgs; [ autotiling ];

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
        menu = "rofi -show drun";
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
          "32904:6:Handle_BYSB.net_SimPad_v2_Gaming_Keyboard" = {
            left_handed = "enabled";
          };
          "9580:109:GAOMON_Gaomon_Tablet_Dial" = { };
        };
        output = {
          "eDP-1" = { bg = "${bgImage} stretch"; };
          "HDMI-A-1" = {
            bg = "${bgImage} stretch";
            pos = "1920 0";
          };
        };
        keybindings = builtins.removeAttrs (lib.mkOptionDefault {
          # Screenshot
          "Shift+Print" = "exec ${screenshot} --snip";
          Print = "exec ${screenshot}";
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
        }) [ "${modifier}+Shift+e" ];
      };

      extraConfig = ''
        bindswitch --reload --locked lid:on output eDP-1 disable
        bindswitch --reload --locked lid:off output eDP-1 enable
        exec dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway XDG_SESSION_TYPE=wayland
        exec systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
        exec systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
        exec mako
        exec_always autotiling
      '';
    };
  };

  environment.systemPackages = with pkgs; [
    greetd.gtkgreet
  ];

  services.greetd =
    let
      swayConfig = pkgs.writeTextFile {
        name = "sway-config";
        text = ''
          include ${pkgs.sway}/etc/sway/config
          exec dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
          exec ${pkgs.greetd.gtkgreet}/bin/gtkgreet \
            -l \
            -c "${if config.samn.system.wireguard.enable then
              "sudo -E ${pkgs.iproute2}/bin/ip netns exec wireguard sudo -E -u #`id -u` "
              else ""} ${pkgs.sway}/bin/sway" \
            -s ${gtkTheme.package}/share/themes/${gtkTheme.name}/gtk-3.0/gtk-dark.css; \
            swaymsg exit
        '';
      };
    in
    {
      enable = true;
      restart = true;
      settings = {
        default_session = {
          command = "${pkgs.sway}/bin/sway --config ${swayConfig}";
        };
      };
    };
}

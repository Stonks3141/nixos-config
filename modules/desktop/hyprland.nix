{ config, lib, pkgs, ... }:
let
  wallpaper = builtins.path {
    path = ./wallpaper.jpg;
    name = "wallpaper";
  };
  screenshot = pkgs.writeScript "screenshot.nu" (builtins.readFile ./screenshot.nu);
  power = pkgs.writeScript "power.nu" (builtins.readFile ./rofi-scripts/power.nu);
  volume = pkgs.writeScript "volume.nu" ''
    PATH=${lib.makeBinPath [ pkgs.pulseaudio ]}:$PATH ${./volume.nu} "$@"
  '';
in
{
  home-manager.users.samn = { pkgs, ... }: {
    home.sessionVariables = {
      HYPRLAND_LOG_WLR = 1;
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
    };

    wayland.windowManager.hyprland = {
      enable = true;
      extraConfig = ''
        monitor=eDP-1,1920x1080@60,0x0,1

        # Switch workspaces
        bind=SUPER,10,workspace,1
        bind=SUPER,11,workspace,2
        bind=SUPER,12,workspace,3
        bind=SUPER,13,workspace,4
        bind=SUPER,14,workspace,5
        bind=SUPER,15,workspace,6
        bind=SUPER,16,workspace,7
        bind=SUPER,17,workspace,8
        bind=SUPER,18,workspace,9

        # Move current window to workspace
        bind=SUPER_SHIFT,10,movetoworkspace,1
        bind=SUPER_SHIFT,11,movetoworkspace,2
        bind=SUPER_SHIFT,12,movetoworkspace,3
        bind=SUPER_SHIFT,13,movetoworkspace,4
        bind=SUPER_SHIFT,14,movetoworkspace,5
        bind=SUPER_SHIFT,15,movetoworkspace,6
        bind=SUPER_SHIFT,16,movetoworkspace,7
        bind=SUPER_SHIFT,17,movetoworkspace,8
        bind=SUPER_SHIFT,18,movetoworkspace,9

        # Move focus
        bind=SUPER,H,movefocus,l
        bind=SUPER,J,movefocus,d
        bind=SUPER,K,movefocus,u
        bind=SUPER,L,movefocus,r

        # Move current window
        bind=SUPER_SHIFT,H,movewindow,l
        bind=SUPER_SHIFT,J,movewindow,d
        bind=SUPER_SHIFT,K,movewindow,u
        bind=SUPER_SHIFT,L,movewindow,r

        bind=SUPER_SHIFT,Q,killactive
        bind=SUPER_SHIFT,E,exec,${pkgs.rofi}/bin/rofi -show power -modes power:${power}

        bind=SUPER,36,exec,${pkgs.kitty}/bin/kitty
        bind=SUPER,D,exec,rofi -show drun

        # Screenshots
        bind=,Print,exec,${screenshot}
        bind=SHIFT,Print,exec,${screenshot} --snip

        # Volume
        binde=,XF86AudioRaiseVolume,exec,${volume} up
        binde=,XF86AudioLowerVolume,exec,${volume} down
        bind=,XF86AudioMute,exec,${volume} mute
        bind=,XF86AudioMicMute,exec,${volume} mic-mute

        # Brightness
        bind=,XF86MonBrightnessDown,exec,${pkgs.brightnessctl}/bin/brightnessctl set 5%-
        bind=,XF86MonBrightnessUp,exec,${pkgs.brightnessctl}/bin/brightnessctl set +5%

        general:gaps_in=5
        general:gaps_out=10
        decoration:rounding=5

        input:repeat_rate=40
        input:repeat_delay=300
        input:left_handed=true
        input:follow_mouse=2

        exec-once=${pkgs.swaybg}/bin/swaybg -i ${wallpaper}
        exec-once=${pkgs.waybar}/bin/waybar
        exec-once=${pkgs.mako}/bin/mako
      '';
    };
  };
}

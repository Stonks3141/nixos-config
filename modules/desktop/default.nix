{ lib, pkgs, ... }: {
  imports = [
    ./sway.nix
    ./hyprland.nix
    ./themes.nix
    ./waybar
    ./rofi.nix
    ./mako.nix
  ];

  config = {
    samn.desktop = {
      mako.enable = lib.mkDefault true;
      rofi.enable = lib.mkDefault true;
    };

    home-manager.users.samn = { pkgs, ... }: {
      home.packages = with pkgs; [
        wayland
        glib
        wl-clipboard
        libnotify
        swaylock
        swayidle
        swaybg
        grim
        slurp
      ];

      home.sessionVariables = {
        _JAVA_AWT_WM_NONREPARENTING = "1";
        XDG_CURRENT_DESKTOP = "hyprland";
        XDG_SESSION_TYPE = "wayland";
      };
    };

    services.dbus.enable = true;
    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
  };
}

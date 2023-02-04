{ lib, pkgs, ... }: {
  imports = [
    ./sway.nix
    ./themes.nix
    ./waybar
    ./rofi
    ./mako.nix
  ];

  options.samn.desktop.enable = lib.mkEnableOption "desktop environment";

  config = {
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
    };

    services.dbus.enable = true;
    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
  };
}

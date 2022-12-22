{ lib, pkgs, ... }: {
  imports = [
    ./sway.nix
    ./themes.nix
    ./waybar
    ./rofi
    ./mako.nix
  ];

  options.samn.desktop = {
    enable = lib.mkEnableOption "desktop environment";
    bgImage = lib.mkOption {
      type = lib.types.str;
      example = "~/foo.png";
    };
    baseColor = lib.mkOption {
      type = lib.types.str;
      example = "fefefe";
    };
    accentColor = lib.mkOption {
      type = lib.types.str;
      example = "fafafa";
    };

    gtkTheme = {
      package = lib.mkOption { type = lib.types.package; };
      name = lib.mkOption { type = lib.types.str; };
    };
    iconTheme = {
      package = lib.mkOption { type = lib.types.package; };
      name = lib.mkOption { type = lib.types.str; };
    };
    cursorTheme = {
      package = lib.mkOption { type = lib.types.package; };
      name = lib.mkOption { type = lib.types.str; };
    };
  };

  config.samn.desktop = {
    bgImage = "/home/samn/mountain.png";
    baseColor = "24273a";
    accentColor = "ed8796";
    gtkTheme = {
      package = pkgs.catppuccin-gtk;
      name = "Catppuccin-Red-Dark";
    };
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
    cursorTheme = {
      package = pkgs.catppuccin-cursors.macchiatoDark;
      name = "Catppuccin-Macchiato-Dark-Cursors";
    };
  };

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

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
    gtkTheme = {
      name = lib.mkOption { type = lib.types.str; };
      package = lib.mkOption { type = lib.types.package; };
    };
  };

  config.samn.desktop = {
    gtkTheme = {
      name = "Catppuccin-Macchiato-Standard-Red-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "red" ];
        variant = "macchiato";
      };
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

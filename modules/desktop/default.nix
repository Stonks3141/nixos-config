{ lib, pkgs, ... }: {
  imports = [
    ./sway.nix
    ./themes.nix
    ./waybar
    ./rofi
    ./mako.nix
  ];

  options.samn.desktop = {
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

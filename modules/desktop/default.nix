# SPDX-FileCopyrightText: 2022 Sam Nystrom <sam@samnystrom.dev>
# SPDX-License-Identifier: CC0-1.0

{ lib, pkgs, ... }: {
  imports = [
    ./dwl.nix
    ./themes.nix
    ./wmenu.nix
    ./mako.nix
  ];

  config = {
    samn.desktop = {
      mako.enable = lib.mkDefault true;
    };

    home-manager.users.samn = { pkgs, ... }: {
      home.packages = with pkgs; [
        wayland
        wl-clipboard
        libnotify
        grim
        slurp
      ];

      home.sessionVariables = {
        _JAVA_AWT_WM_NONREPARENTING = "1";
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

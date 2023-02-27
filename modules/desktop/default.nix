{ lib, pkgs, ... }: {
  imports = [
    ./dwl.nix
    ./themes.nix
    ./waybar
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
        libsForQt5.polkit-kde-agent
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

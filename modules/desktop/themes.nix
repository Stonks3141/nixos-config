{ config, pkgs, lib, ... }:
let
  gtkTheme = config.samn.desktop.gtkTheme;
  iconTheme = {
    package = pkgs.papirus-icon-theme;
    name = "Papirus-Dark";
  };
  cursorTheme = {
    package = pkgs.catppuccin-cursors.macchiatoDark;
    name = "Catppuccin-Macchiato-Dark-Cursors";
  };
in
{
  home-manager.users.samn = { pkgs, ... }: {
    home.pointerCursor = {
      package = cursorTheme.package;
      name = cursorTheme.name;
      size = 16;
      gtk.enable = true;
    };

    dconf.settings."org/gnome/desktop/interface" = {
      gtk-theme = gtkTheme.name;
      icon-theme = iconTheme.name;
      cursor-theme = cursorTheme.name;
    };

    gtk = {
      enable = true;
      theme = {
        package = gtkTheme.package;
        name = gtkTheme.name;
      };
      iconTheme = {
        package = iconTheme.package;
        name = iconTheme.name;
      };
      gtk2.extraConfig = ''
        gtk-cursor-theme-name = ${cursorTheme.name}
        gtk-cursor-theme-size = 0
      '';
      gtk3.extraConfig = {
        gtk-cursor-theme-name = cursorTheme.name;
        gtk-cursor-theme-size = 0;
      };
    };
  };
}

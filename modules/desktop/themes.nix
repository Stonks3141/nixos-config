# SPDX-FileCopyrightText: 2022 Sam Nystrom <sam@samnystrom.dev>
# SPDX-License-Identifier: CC0-1.0

{ config, pkgs, lib, ... }:
let
  cfg = config.samn.desktop.themes;
  # capitalize first letter
  firstUpper = with lib.strings;
    str: concatImapStrings (i: v: if i == 1 then toUpper v else v) (stringToCharacters str);
  gtkTheme = {
    name = "Catppuccin-${firstUpper cfg.gtk.catppuccin}-Standard-${firstUpper cfg.gtk.accent}-Dark";
    package = pkgs.catppuccin-gtk.override {
      accents = [ cfg.gtk.accent ];
      variant = cfg.gtk.catppuccin;
    };
  };
  iconTheme = {
    package = pkgs.papirus-icon-theme;
    name = "Papirus-Dark";
  };
  cursorTheme = {
    package = pkgs.catppuccin-cursors."${cfg.cursor.catppuccin}Dark";
    name = "Catppuccin-${firstUpper cfg.cursor.catppuccin}-Dark-Cursors";
  };
in
{
  options.samn.desktop.themes = {
    gtk = {
      catppuccin = lib.mkOption {
        type = lib.types.enum [ "mocha" "macchiato" "frappe" "latte" ];
        default = config.samn.catppuccin;
        description = "Catppuccin flavor for GTK";
      };
      accent = lib.mkOption {
        type = lib.types.enum [
          "rosewater"
          "flamingo"
          "pink"
          "mauve"
          "red"
          "maroon"
          "peach"
          "yellow"
          "green"
          "teal"
          "sky"
          "sapphire"
          "blue"
          "lavender"
        ];
        default = config.samn.accent;
        description = "Catppuccin accent for GTK";
      };
    };
    icon.catppuccin = lib.mkOption {
      type = lib.types.enum [ "mocha" "macchiato" "frappe" "latte" ];
      default = config.samn.catppuccin;
      description = "Catppuccin icon flavor";
    };
    cursor.catppuccin = lib.mkOption {
      type = lib.types.enum [ "mocha" "macchiato" "frappe" "latte" ];
      default = config.samn.catppuccin;
      description = "Catppuccin flavor for the cursor";
    };
  };

  config.home-manager.users.samn = { pkgs, ... }: {
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

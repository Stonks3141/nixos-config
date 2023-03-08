# SPDX-FileCopyrightText: 2022 Sam Nystrom <sam@samnystrom.dev>
# SPDX-License-Identifier: CC0-1.0

{ config, pkgs, lib, ... }: {
  imports = [
    ./secrets.nix
    ./desktop
    ./applications
    ./system.nix
    ./network.nix
  ];

  options.samn = {
    catppuccin = lib.mkOption {
      type = lib.types.enum [ "mocha" "macchiato" "frappe" "latte" ];
      default = "latte";
      description = "Global catppuccin flavor";
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
      default = "rosewater";
      description = "Global catppuccin accent color";
    };
  };

  config = {
    nix.settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };

    fonts.fonts = with pkgs; [
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
      noto-fonts
    ];

    home-manager.users.samn = { pkgs, ... }:
      let home = config.users.users.samn.home; in {
        home.stateVersion = config.samn.system.stateVersion;
        home.sessionVariables = {
          EDITOR = "${pkgs.helix}/bin/hx";
          PAGER = "${pkgs.less}/bin/less";
          BROWSER = "${pkgs.firefox}/bin/firefox";
          TERMINAL = "${pkgs.foot}/bin/foot";
          XDG_DOWNLOADS_DIR = "${home}/Downloads";
          XDG_CONFIG_HOME = "${home}/.config";
          XDG_DATA_HOME = "${home}/.local/share";
        };
        nixpkgs.config.allowUnfree = true;
      };
  };
}

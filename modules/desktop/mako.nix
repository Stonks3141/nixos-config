# SPDX-FileCopyrightText: 2022 Sam Nystrom <sam@samnystrom.dev>
# SPDX-License-Identifier: CC0-1.0

{ config, lib, ... }:
let
  cfg = config.samn.desktop.mako;
in
{
  options.samn.desktop.mako = {
    enable = lib.mkEnableOption "mako";
    catppuccin = lib.mkOption {
      type = lib.types.enum [ "mocha" "macchiato" "frappe" "latte" ];
      default = config.samn.catppuccin;
      description = "Catppuccin flavor for mako";
    };
  };

  config.home-manager.users.samn = { pkgs, ... }: {
    services.mako = lib.mkIf cfg.enable {
      enable = true;
      font = "FiraCode Nerd Font 10";

      borderSize = 2;
      borderRadius = 3;
      margin = "20";
      extraConfig = builtins.readFile (pkgs.fetchFromGitHub
        {
          owner = "catppuccin";
          repo = "mako";
          rev = "64ef71633528b50e5475755e50071584b54fa291";
          sha256 = "sha256-J2PaPfBBWcqixQGo3eNVvLz2EZWD92RfD0MfbEDK/wA=";
        } + /src/${cfg.catppuccin});
    };
  };
}

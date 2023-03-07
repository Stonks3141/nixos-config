# SPDX-FileCopyrightText: 2023 Sam Nystrom <sam@samnystrom.dev>
# SPDX-License-Identifier: CC0-1.0

{ config, lib, ... }:
let
  cfg = config.samn.applications.helix;
in
{
  options.samn.applications.helix = {
    enable = lib.mkEnableOption "helix";
    catppuccin = lib.mkOption {
      type = lib.types.enum [ "mocha" "macchiato" "frappe" "latte" ];
      default = config.samn.catppuccin;
      description = "Catppuccin flavor for helix";
    };
  };

  config.home-manager.users.samn = { pkgs, ... }: {
    programs.helix = lib.mkIf cfg.enable {
      enable = true;
      settings = {
        theme = "ctp";
        editor = {
          gutters = [ "diagnostics" "spacer" "line-numbers" "spacer" "diff" ];
          bufferline = "always";
          mouse = false;
          indent-guides.render = true;
        };
      };
      languages = [
        {
          name = "rust";
          config.checkOnSave.command = "clippy";
        }
        {
          name = "nix";
          formatter.command = "nixpkgs-fmt";
        }
      ];
      themes.ctp = {
        inherits = "catppuccin_${cfg.catppuccin}";
        hint.fg = "text";
        info.fg = "blue";
        warning.fg = "peach";
        error.fg = "red";
        "diagnostic.hint".underline = { style = "curl"; color = "text"; };
        "diagnostic.info".underline = { style = "curl"; color = "blue"; };
        "diagnostic.warning".underline = { style = "curl"; color = "peach"; };
        "diagnostic.error".underline = { style = "curl"; color = "red"; };
      };
    };
  };
}

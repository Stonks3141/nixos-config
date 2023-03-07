# SPDX-FileCopyrightText: 2022 Sam Nystrom <sam@samnystrom.dev>
# SPDX-License-Identifier: CC0-1.0

{ config, pkgs, lib, ... }:
let
  cfg = config.samn.applications.firefox;
  nur = pkgs.nur;
  addonId = "foo";
  catppuccin-colors = pkgs.stdenvNoCC.mkDerivation {
    name = "catppuccin-firefox-colors";
    src = pkgs.fetchFromGitHub
      {
        owner = "catppuccin";
        repo = "firefox";
        rev = "old";
        sha256 = "sha256-ZIK0LX8OJOBr20diRDQRrNc1X+q3DtHNcc/dRZU2QfM=";
      } + /releases/old/catppuccin_${cfg.catppuccin}_${cfg.accent}.xpi;

    preferLocalBuild = true;
    allowSubstitutes = true;
    buildCommand = ''
      dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
      mkdir -p "$dst"
      install -v -m644 "$src" "$dst/${addonId}.xpi"
    '';
  };
in
{
  options.samn.applications.firefox = {
    enable = lib.mkEnableOption "firefox";
    catppuccin = lib.mkOption {
      type = lib.types.enum [ "mocha" "macchiato" "frappe" "latte" ];
      default = config.samn.catppuccin;
      description = "Catppuccin flavor for firefox";
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
      description = "Firefox catppuccin accent color";
    };
  };

  config.home-manager.users.samn = { pkgs, ... }: {
    programs.firefox = lib.mkIf cfg.enable {
      enable = true;
      profiles.default = {
        search = {
          default = "DuckDuckGo";
          force = true;
        };
        extensions = with nur.repos.rycee.firefox-addons; [
          ublock-origin
          bitwarden
          stylus
          catppuccin-colors
        ];
        settings = {
          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.socialtracking.enabled" = true;
          "dom.security.https_only_mode" = true;
          "dom.security.https_only_mode_ever_enabled" = true;
        };
      };
    };
  };
}

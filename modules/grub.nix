{ config, pkgs, lib, ... }:
let
  cfg = config.samn.grub;
  catppuccin-grub = pkgs.stdenvNoCC.mkDerivation {
    name = "catppuccin-grub";
    src = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "grub";
      rev = "803c5df0e83aba61668777bb96d90ab8f6847106";
      sha256 = "sha256-/bSolCta8GCZ4lP0u5NVqYQ9Y3ZooYCNdTwORNvR7M0=";
    };
    installPhase = ''
      mkdir -p $out
      cp -r ./src/catppuccin-${cfg.catppuccin}-grub-theme/* $out
    '';
  };
in
{
  options.samn.grub = {
    catppuccin = lib.mkOption {
      type = lib.types.enum [ "mocha" "macchiato" "frappe" "latte" ];
      default = config.samn.catppuccin;
      description = "Catppuccin flavor for grub";
    };
  };

  config.boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;

    font = "${catppuccin-grub}/font.pf2";
    splashImage = "${catppuccin-grub}/background.png";
    theme = catppuccin-grub;
  };
}

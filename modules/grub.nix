{ pkgs, ... }:
let
  catppuccin-grub = pkgs.stdenvNoCC.mkDerivation rec {
    name = "catppuccin-grub";
    src = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "grub";
      rev = "803c5df0e83aba61668777bb96d90ab8f6847106";
      sha256 = "sha256-/bSolCta8GCZ4lP0u5NVqYQ9Y3ZooYCNdTwORNvR7M0=";
    };
    installPhase = ''
      mkdir -p $out
      cp -r ./src/catppuccin-macchiato-grub-theme/* $out
    '';
  };
in
{
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;

    font = "${catppuccin-grub}/font.pf2";
    splashImage = "${catppuccin-grub}/background.png";
    theme = catppuccin-grub;
  };
}

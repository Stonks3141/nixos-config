{ pkgs, ... }:
let
  catppuccin-grub = pkgs.stdenvNoCC.mkDerivation {
    name = "catppuccin-grub";
    src = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "grub";
      rev = "803c5df0e83aba61668777bb96d90ab8f6847106";
      sha256 = "sha256-/bSolCta8GCZ4lP0u5NVqYQ9Y3ZooYCNdTwORNvR7M0=";
    };
    installPhase = ''
      mkdir -p $out/share/grub/themes
      cp -r src/* $out/share/grub/themes/
      mkdir -p $out/etc/default
      echo "GRUB_THEME='$out/share/grub/themes/catppuccin-macchiato-grub-theme/theme.txt'" >> $out/etc/default/grub
    '';
  };
in
{
  environment.systemPackages = [ catppuccin-grub ];
  # boot.loader.grub.theme = "${catppuccin-grub}/share/grub/themes/catppuccin-macchiato-grub-theme/theme.txt";
  boot.loader.grub.theme = pkgs.nixos-grub2-theme;
}

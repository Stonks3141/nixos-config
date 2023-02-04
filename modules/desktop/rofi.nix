{ config, lib, ... }:
let
  cfg = config.samn.desktop.rofi;
in
{
  options.samn.desktop.rofi = {
    enable = lib.mkEnableOption "rofi";
    catppuccin = lib.mkOption {
      type = lib.types.enum [ "mocha" "macchiato" "frappe" "latte" ];
      default = config.samn.catppuccin;
      description = "Catppuccin flavor for rofi";
    };
  };

  config.home-manager.users.samn = { pkgs, ... }: {
    programs.rofi = lib.mkIf cfg.enable {
      enable = true;
      font = "FiraCode Nerd Font 12";
      terminal = "${pkgs.kitty}/bin/kitty";
      theme = pkgs.fetchFromGitHub
        {
          owner = "catppuccin";
          repo = "rofi";
          rev = "5350da41a11814f950c3354f090b90d4674a95ce";
          sha256 = "sha256-DNorfyl3C4RBclF2KDgwvQQwixpTwSRu7fIvihPN8JY=";
        } + /basic/.local/share/rofi/themes/catppuccin-${cfg.catppuccin}.rasi;
    };
  };
}

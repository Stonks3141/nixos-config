{ config, lib, ... }:
let
  cfg = config.samn.applications.kitty;
  # capitalize first letter
  flavor = with lib; strings.concatStrings (
    lists.imap0
      (i: v: if i == 0 then strings.toUpper v else v)
      (strings.stringToCharacters cfg.catppuccin)
  );
in
{
  options.samn.applications.kitty = {
    enable = lib.mkEnableOption "kitty";
    catppuccin = lib.mkOption {
      type = lib.types.enum [ "mocha" "macchiato" "frappe" "latte" ];
      default = config.samn.catppuccin;
      description = "Catppuccin flavor for kitty";
    };
  };

  config.home-manager.users.samn = { pkgs, ... }: {
    programs.kitty = lib.mkIf cfg.enable {
      enable = true;
      font = {
        package = (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; });
        name = "FiraCode Nerd Font";
        size = 10;
      };
      theme = "Catppuccin-${flavor}";
      settings.enable_audio_bell = false;
    };
  };
}

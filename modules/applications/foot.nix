{ config, lib, ... }:
let
  cfg = config.samn.applications.foot;
  theme = builtins.fromTOML (builtins.readFile (pkgs.stdenvNoCC.mkDerivation {
    name = "foot-catppuccin";
    src = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "foot";
      rev = "79ab526a1428318dba793d58afd1d2545ed3cb7c";
      sha256 = "sha256-QojvIlaheEsHvv1vOIVEWg7eTo9zlcdkpb33BJLQB9M=";
    };
    buildPhase = ''
      # Very jank ini->toml conversion that works for this specific file
      sed -E -i 's/([^=]+)=(\S*)/\1="\2"/g' catppuccin-${cfg.catppuccin}.conf
    '';
    installPhase = ''
      cp catppuccin-${cfg.catppuccin}.conf $out
    '';
  }));
in
{
  options.samn.applications.foot = {
    enable = lib.mkEnableOption "foot";
    catppuccin = lib.mkOption {
      type = lib.types.enum [ "mocha" "macchiato" "frappe" "latte" ];
      default = config.samn.catppuccin;
      description = "Catppuccin flavor for foot";
    };
  };

  config.home-manager.users.samn = { pkgs, ... }: {
    programs.foot = lib.mkIf cfg.enable {
      enable = true;
      settings = {
        main.font = "FiraCode Nerd Font:size=7";
      } // theme;
    };
  };
}

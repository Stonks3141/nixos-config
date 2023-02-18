{ config, lib, ... }:
let
  cfg = config.samn.applications.starship;
  flavor = cfg.catppuccin;
in
{
  options.samn.applications.starship = {
    enable = lib.mkEnableOption "starship";
    catppuccin = lib.mkOption {
      type = lib.types.enum [ "mocha" "macchiato" "frappe" "latte" ];
      default = config.samn.catppuccin;
      description = "Catppuccin flavor for starship";
    };
  };

  config.home-manager.users.samn = { pkgs, ... }: {
    programs.starship = lib.mkIf cfg.enable {
      enable = true;
      settings = {
        format = "$all";
        palette = "catppuccin_${flavor}";
      } // builtins.fromTOML (builtins.readFile
        (pkgs.fetchFromGitHub
          {
            owner = "JoshPaulie";
            repo = "starship";
            rev = "3618616ce25d03eb411d8ca880e89b1dcf8745cc";
            sha256 = "sha256-5iwRfu92dnDMu3YEN6EBzoBPImWOKAw1QB2qSqXKJlA=";
          } + /palettes/${flavor}.toml));
    };
  };
}

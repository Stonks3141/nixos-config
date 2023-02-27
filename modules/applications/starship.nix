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
            owner = "catppuccin";
            repo = "starship";
            rev = "3e3e54410c3189053f4da7a7043261361a1ed1bc";
            sha256 = "sha256-soEBVlq3ULeiZFAdQYMRFuswIIhI9bclIU8WXjxd7oY=";
          } + /palettes/${flavor}.toml));
    };
  };
}

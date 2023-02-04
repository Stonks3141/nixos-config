{ config, lib, ... }:
let
  cfg = config.samn.applications.bottom;
in
{
  options.samn.applications.bottom = {
    enable = lib.mkEnableOption "bottom";
    catppuccin = lib.mkOption {
      type = lib.types.enum [ "mocha" "macchiato" "frappe" "latte" ];
      default = config.samn.catppuccin;
      description = "Catppuccin flavor for bottom";
    };
  };

  config.home-manager.users.samn = { pkgs, ... }: {
    programs.bottom = lib.mkIf cfg.enable {
      enable = true;
      settings.colors = (builtins.fromTOML (builtins.readFile (pkgs.fetchFromGitHub
        {
          owner = "catppuccin";
          repo = "bottom";
          rev = "c0efe9025f62f618a407999d89b04a231ba99c92";
          sha256 = "sha256-VaHX2I/Gn82wJWzybpWNqU3dPi3206xItOlt0iF6VVQ=";
        } + /themes/${cfg.catppuccin}.toml))).colors;
    };
  };
}

{ config, lib, ... }:
let
  cfg = config.samn.applications.bat;
  flavor = cfg.catppuccin;
in
{
  options.samn.applications.bat = {
    enable = lib.mkEnableOption "bat";
    catppuccin = lib.mkOption {
      type = lib.types.enum [ "mocha" "macchiato" "frappe" "latte" ];
      default = config.samn.catppuccin;
      description = "Catppuccin flavor for bat";
    };
  };

  config.home-manager.users.samn = { pkgs, ... }: {
    home.activation = {
      batCache = "${pkgs.bat}/bin/bat cache --build";
    };

    programs.bat = lib.mkIf cfg.enable {
      enable = true;
      config.theme = "Catppuccin-${flavor}";
      themes."Catppuccin-${flavor}" = builtins.readFile (pkgs.fetchFromGitHub
        {
          owner = "catppuccin";
          repo = "bat";
          rev = "ba4d16880d63e656acced2b7d4e034e4a93f74b1";
          sha256 = "sha256-6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
        } + /Catppuccin-${flavor}.tmTheme);
    };
  };
}

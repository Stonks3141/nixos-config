{ config, lib, ... }: {
  imports = [
    ./secrets.nix
    ./desktop
    ./applications
    ./fonts.nix
    ./system.nix
    ./network.nix
    ./grub.nix
  ];

  options.samn = {
    catppuccin = lib.mkOption {
      type = lib.types.enum [ "mocha" "macchiato" "frappe" "latte" ];
      default = "latte";
      description = "Global catppuccin flavor";
    };
    accent = lib.mkOption {
      type = lib.types.enum [
        "rosewater"
        "flamingo"
        "pink"
        "mauve"
        "red"
        "maroon"
        "peach"
        "yellow"
        "green"
        "teal"
        "sky"
        "sapphire"
        "blue"
        "lavender"
      ];
      default = "rosewater";
      description = "Global catppuccin accent color";
    };
  };

  config = {
    nix.settings = {
      experimental-features = [ "nix-command" "flakes" ];
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };

    environment.variables = {
      XDG_CURRENT_DESKTOP = "sway";
      XDG_SESSION_TYPE = "wayland";
    };

    environment.sessionVariables = {
      XDG_CURRENT_DESKTOP = "sway";
      XDG_SESSION_TYPE = "wayland";
    };

    home-manager.users.samn = { pkgs, ... }: {
      home.stateVersion = config.samn.system.stateVersion;
      home.sessionVariables = {
        EDITOR = "hx";
        BROWSER = "firefox";
        TERMINAL = "kitty";
        XDG_DOWNLOADS_DIR = "~/Downloads";
      };
      nixpkgs.config.allowUnfree = true;
    };
  };
}

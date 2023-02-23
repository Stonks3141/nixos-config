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

    home-manager.users.samn = { pkgs, ... }: {
      home.stateVersion = config.samn.system.stateVersion;
      home.sessionVariables = {
        EDITOR = "${pkgs.helix}/bin/hx";
        GIT_EDITOR = "${pkgs.helix}/bin/hx";
        BROWSER = "${pkgs.firefox}/bin/firefox";
        TERMINAL = "${pkgs.kitty}/bin/kitty";
        XDG_DOWNLOADS_DIR = "~/Downloads";
        XDG_CONFIG_HOME = "~/.config";
        XDG_DATA_HOME = "~/.local/share";
      };
      nixpkgs.config.allowUnfree = true;
    };
  };
}

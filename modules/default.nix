{ config, pkgs, lib, ... }: {
  imports = [
    ./secrets.nix
    ./desktop
    ./applications
    ./system.nix
    ./network.nix
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
    };

    fonts.fonts = with pkgs; [
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
      noto-fonts
    ];

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

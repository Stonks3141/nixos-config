{ config, lib, ... }: {
  imports = [
    ./desktop
    ./applications
    ./fonts.nix
    ./system.nix
    ./secrets.nix
  ];

  config.environment.variables = {
    XDG_CURRENT_DESKTOP = "sway";
    XDG_SESSION_TYPE = "wayland";
  };

  config.environment.sessionVariables = {
    XDG_CURRENT_DESKTOP = "sway";
    XDG_SESSION_TYPE = "wayland";
  };

  config.home-manager.users.samn = { pkgs, ... }: {
    home.stateVersion = config.samn.system.stateVersion;
    home.sessionVariables = {
      EDITOR = "hx";
      BROWSER = "firefox";
      TERMINAL = "kitty";
      XDG_DOWNLOADS_DIR = "~/Downloads";
      XDG_CURRENT_DESKTOP = "sway";
      XDG_SESSION_TYPE = "wayland";
    };
    systemd.user.sessionVariables = {
      XDG_CURRENT_DESKTOP = "sway";
      XDG_SESSION_TYPE = "wayland";
    };
    nixpkgs.config = {
      allowUnfree = true;
      packageOverrides = pkgs: {
        nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
          inherit pkgs;
        };
      };
    };
  };
}

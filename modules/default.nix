{ config, lib, ... }: {
  imports = [
    ./desktop
    ./applications
    ./fonts.nix
    ./secrets.nix
  ];

  options.samn.stateVersion = lib.mkOption {
    type = lib.types.str;
    example = "22.11";
  };

  config.home-manager.users.samn = { pkgs, ... }: {
    home.stateVersion = config.samn.stateVersion;
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

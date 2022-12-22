{
  description = "NixOS configuration flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        utils.follows = "flake-utils";
      };
    };
    utils = {
      url = "github:gytis-ivaskevicius/flake-utils-plus";
      inputs.flake-utils.follows = "flake-utils";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    devshell = {
      url = "github:numtide/devshell";
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };
  };
  outputs = inputs@{ self, nixpkgs, nur, home-manager, utils, agenix, ... }: utils.lib.mkFlake {
    inherit self inputs;
    channels.nixpkgs = {
      input = nixpkgs;
      config.allowUnfree = true;
      overlaysBuilder = _: [ nur.overlay ];
    };
    hostDefaults.modules = [
      home-manager.nixosModule
      agenix.nixosModule
      ./modules
    ];
    hosts = {
      pavilion.modules = [ ./hosts/pavilion ];
    };
    outputsBuilder = channels: {
      devShell = channels.nixpkgs.mkShell {
        name = "nixos-config";
        packages = with channels.nixpkgs; [
          nil
          nixpkgs-fmt
          agenix.defaultPackage.x86_64-linux
        ];
      };
    };
  };
}

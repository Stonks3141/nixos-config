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
      inputs = {
        flake-utils.follows = "flake-utils";
      };
    };
  };
  outputs = inputs@{ self, nixpkgs, nur, home-manager, utils, ... }: utils.lib.mkFlake {
    inherit self inputs;
    channels.nixpkgs = {
      input = nixpkgs;
      config.allowUnfree = true;
      overlaysBuilder = _: [ nur.overlay ];
    };
    hostDefaults.modules = [
      home-manager.nixosModule
      ./modules
      ./hardware-configuration.nix
    ];
    hosts = {
      pavilion.modules = [ ./hosts/pavilion ];
    };
  };
}

{
  description = "NixOS configuration flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    agenix.url = "github:ryantm/agenix";
    hyprland.url = "github:hyprwm/Hyprland";
  };
  outputs = inputs@{ self, nixpkgs, nur, home-manager, utils, agenix, hyprland, ... }: utils.lib.mkFlake {
    inherit self inputs;
    channels.nixpkgs = {
      input = nixpkgs;
      config.allowUnfree = true;
      overlaysBuilder = _: [ nur.overlay ];
    };
    hostDefaults.modules = [
      home-manager.nixosModules.default
      {
        home-manager.sharedModules = [ hyprland.homeManagerModules.default ];
      }
      hyprland.nixosModules.default
      agenix.nixosModules.default
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
          agenix.packages.x86_64-linux.default
        ];
      };
    };
  };
}

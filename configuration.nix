{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    <home-manager/nixos>
    ./modules
    ./hosts/pavilion
  ];
}

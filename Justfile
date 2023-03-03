default:
  @just --list

switch *FLAGS='.':
  doas nixos-rebuild switch --flake {{FLAGS}}

build *FLAGS='.':
  doas nixos-rebuild build --flake {{FLAGS}}

test *FLAGS='.':
  doas nixos-rebuild test --flake {{FLAGS}}

boot *FLAGS='.':
  doas nixos-rebuild boot --flake {{FLAGS}}

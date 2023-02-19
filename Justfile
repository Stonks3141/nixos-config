default:
  @just --list

switch *FLAGS='.':
  sudo nixos-rebuild switch --flake {{FLAGS}}

build *FLAGS='.':
  sudo nixos-rebuild build --flake {{FLAGS}}

test *FLAGS='.':
  sudo nixos-rebuild test --flake {{FLAGS}}

boot *FLAGS='.':
  sudo nixos-rebuild boot --flake {{FLAGS}}

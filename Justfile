# SPDX-FileCopyrightText: 2023 Sam Nystrom <sam@samnystrom.dev>
# SPDX-License-Identifier: CC0-1.0

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

# SPDX-FileCopyrightText: 2023 Sam Nystrom <sam@samnystrom.dev>
# SPDX-License-Identifier: CC0-1.0

{ pkgs, ... }:
let
  wmenu = pkgs.stdenv.mkDerivation rec {
    pname = "wmenu";
    version = "0.1.2";
    src = pkgs.fetchFromSourcehut {
      owner = "~adnano";
      repo = "wmenu";
      rev = version;
      sha256 = "sha256-mS4qgf2sjgswasZXsmnbIWlqVv+Murvx1/ob0G3xsws=";
    };
    buildInputs = with pkgs; [
      pkg-config
      meson
      ninja
      scdoc
    ];
    nativeBuildInputs = with pkgs; [
      cairo
      pango
      wayland
      wayland-protocols
      libxkbcommon
    ];
    dontConfigure = true;
    buildPhase = ''
      CFLAGS="-O" meson build --prefix $out
      ninja -C build
    '';
    installPhase = ''
      ninja -C build install
    '';
  };
  wmenu-wrapped = pkgs.writeScriptBin "wmenu" ''
    ${wmenu}/bin/wmenu \
      -N 24273a -n cad3f5 -M c6a0f6 -m 24273a -S 24273a -s c6a0f6 \
      -f "FiraCode Nerd Font 12.2" \
      "$@"
  '';
  path = pkgs.writeScript "list-path" ''
    (IFS=:
      for p in $PATH; do
        ls 2>/dev/null -1 "$p"
      done
    )
  '';
  wmenu-run = pkgs.writeScriptBin "wmenu-run" ''
    exec $(${path} | ${wmenu-wrapped}/bin/wmenu -p "Run:")
  '';
in
{
  config.home-manager.users.samn = { ... }: {
    home.packages = [ wmenu-wrapped wmenu-run ];
  };
}

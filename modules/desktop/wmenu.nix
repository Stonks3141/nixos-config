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
    ${wmenu}/bin/wmenu -N 181926 -n cad3f5 -M 1e2030 -m cad3f5 -S ed8796 -s 181926 "$@"
  '';
  path = pkgs.writeScript "list-path" ''
    #!/bin/sh

    (IFS=:
      for p in $PATH; do
        ls -1 "$p"
      done
    )
  '';
  run = pkgs.writeScriptBin "wmenu-run" ''
    exec $(${path} | ${wmenu-wrapped}/bin/wmenu)
  '';
in
{
  config.home-manager.users.samn = { ... }: {
    home.packages = [ wmenu-wrapped run ];
  };
}

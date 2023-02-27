{ pkgs, ... }:
let
  wmenu = pkgs.stdenv.mkDerivation {
    src = pkgs.fetchFromSourcehut rec {
      pname = "wmenu";
      version = "0.1.2";
      rev = version;
      sha256 = "";
    };
    buildInputs = with pkgs; [
      meson
      ninja
    ];
    nativeBuildInputs = with pkgs; [
      cairo
      pango
      wayland
      libxkbcommon
      scdoc
    ];
    buildPhase = ''
      meson build
      ninja -C build
    '';
    installPhase = ''
      ninja -C build install
    '';
  };
in
{
  config.home-manager.users.samn = { ... }: {
    home.packages = [ wmenu ];
  };
}

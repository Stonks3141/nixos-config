{ config, lib, pkgs, ... }:
let
  wallpaper = builtins.path {
    path = ./wallpaper.jpg;
    name = "wallpaper";
  };
  somebar = pkgs.somebar.override {
    conf = ./config.def.hpp;
  };
  status = pkgs.writeShellApplication {
    name = "status.sh";
    runtimeInputs = [ pkgs.pulseaudio pkgs.brightnessctl somebar ];
    text = (builtins.readFile ./status.sh);
  };
  init = pkgs.writeScript "dwl-init" ''
    ${pkgs.swaybg}/bin/swaybg -i ${wallpaper} \
    & ${somebar}/bin/somebar \
    & ${status}/bin/status.sh \
    & ${pkgs.swayidle}/bin/swayidle -w \
      timeout 300 '${pkgs.swaylock}/bin/swaylock -f -i ${wallpaper}' \
      before-sleep '${pkgs.swaylock}/bin/swaylock -f -i ${wallpaper}'
  '';
  dwl = (pkgs.dwl.override { conf = ./config.def.h; }).overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      (pkgs.fetchpatch {
        url = "https://github.com/djpohly/dwl/compare/main...sevz17:vanitygaps.patch";
        sha256 = "sha256-MZqCxD+nTM7YaEVENxvnNVlGQ0og+gb+9kIS7EVtMUQ=";
      })
    ];
  });
in
{
  services.greetd = {
    enable = true;
    restart = true;
    vt = 7;
    settings = {
      default_session = {
        command = ''
          ${pkgs.greetd.tuigreet}/bin/tuigreet \
            --user-menu \
            --user-menu-min-uid 1000 \
            --user-menu-max-uid 30000 \
            --asterisks \
            --power-shutdown 'systemctl shutdown' \
            --power-reboot 'systemctl reboot' \
            --cmd '${dwl}/bin/dwl -s ${init}'
        '';
      };
    };
  };
}

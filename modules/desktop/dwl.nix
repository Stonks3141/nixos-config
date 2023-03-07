# SPDX-FileCopyrightText: 2023 Sam Nystrom <sam@samnystrom.dev>
# SPDX-License-Identifier: CC0-1.0

{ config, lib, pkgs, ... }:
let
  wallpaper = builtins.path {
    path = ./wallpaper.jpg;
    name = "wallpaper";
  };
  somebar = (pkgs.somebar.override { conf = ./config.hpp; }).overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      (pkgs.fetchpatch {
        url = "https://git.sr.ht/~raphi/somebar/blob/master/contrib/colorless-status.patch";
        sha256 = "sha256-MSReljoSB0wS1gPumrGNz15UVyP/p9geshbrr+dY2Pw=";
      })
      (pkgs.fetchpatch {
        url = "https://git.sr.ht/~raphi/somebar/blob/master/contrib/dwm-like-tag-indicator.patch";
        sha256 = "sha256-FvdzGGeOBDyFsyoBELNIYWAonDInRuOsOzpeePRo4zk=";
      })
      (pkgs.fetchpatch {
        url = "https://git.sr.ht/~raphi/somebar/blob/master/contrib/markup-in-status-messages.patch";
        sha256 = "sha256-QHGgez/fC7nEHKQqKgxY5RkVUB4ySxCd4a8lTWiDZtY=";
      })
    ];
  });
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
  dwl = (pkgs.dwl.override { conf = ./config.h; }).overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      (pkgs.fetchpatch {
        url = "https://github.com/djpohly/dwl/compare/main...sevz17:vanitygaps.patch";
        sha256 = "sha256-MZqCxD+nTM7YaEVENxvnNVlGQ0og+gb+9kIS7EVtMUQ=";
      })
    ];
    NIX_CFLAGS_COMPILE = (old.NIX_CFLAGS_COMPILE or [ ]) ++ [ "-Wno-unused-function" ];
  });
  dwl-wrapped = pkgs.writeShellApplication {
    name = "dwl";
    runtimeInputs = with pkgs; [ pulseaudio brightnessctl ];
    text = ''
      ${dwl}/bin/dwl "$@"
    '';
  };
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
            --cmd '${dwl-wrapped}/bin/dwl -s ${init}'
        '';
      };
    };
  };
}

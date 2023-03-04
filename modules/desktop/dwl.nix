{ config, lib, pkgs, ... }:
let
  wallpaper = builtins.path {
    path = ./wallpaper.jpg;
    name = "wallpaper";
  };
  somebar = pkgs.somebar.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [ ../../patches/somebar.patch ];
  });
  status = pkgs.writeShellApplication {
    name = "status.sh";
    runtimeInputs = with pkgs; [ pulseaudio brightnessctl ];
    text = (builtins.readFile ./status.sh);
  };
  init = pkgs.writeScript "dwl-init" ''
    ${pkgs.swaybg}/bin/swaybg -i ${wallpaper} \
    & ${somebar}/bin/somebar \
    & ${status} \
    & ${pkgs.swayidle}/bin/swayidle -w \
      timeout 300 '${pkgs.swaylock}/bin/swaylock -f -i ${wallpaper}' \
      before-sleep '${pkgs.swaylock}/bin/swaylock -f -i ${wallpaper}'
  '';
  dwl = pkgs.dwl.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      # pkgs.fetchurl {
      #   url = "https://git.sr.ht/~stonks3141/dwl/commit/a21980497c9cfe195b79295c70971933ae3a3601.patch";
      #   sha256 = "";
      # }
      ../../patches/gaps.patch
      # pkgs.fetchurl {
      #   url = "https://git.sr.ht/~stonks3141/dwl/commit/212ed89366f45f43248b054faa474ab9c9928307.patch";
      #   sha256 = "";
      # }
      ../../patches/config.patch
    ];
    # src = pkgs.fetchFromSourcehut {
    #   owner = "~stonks3141";
    #   repo = "dwl";
    #   rev = "e4d67b2f1e2dcd013d2d3d9d3c475db98e28d611";
    #   sha256 = "sha256-IZ3k+9pXIJKRHoWeLyOX9GG+iJkUweykps/QeYKCtIU=";
    # };
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

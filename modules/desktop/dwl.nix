{ lib, ... }: {
  home-manager.users.samn = { pkgs, ... }:
    let
      wallpaper = builtins.path {
        path = ./wallpaper.jpg;
        name = "wallpaper";
      };
      screenshot = pkgs.writeScript "screenshot.nu" (builtins.readFile ./screenshot.nu);
      power = pkgs.writeScript "power.nu" (builtins.readFile ./rofi-scripts/power.nu);
      volume = pkgs.writeScript "volume.nu" ''
        PATH=${lib.makeBinPath [ pkgs.pulseaudio ]}:$PATH ${./volume.nu} "$@"
      '';
      init = pkgs.writeScript "dwl-init" ''
        swaybg -i ${wallpaper} & ${pkgs.waybar}/bin/waybar
      '';
      dwl = pkgs.writeScriptBin "dwl" ''
        ${pkgs.dwl}/bin/dwl -s ${init}
      '';
    in
    {
      nixpkgs.overlays = [
        (self: super: {
          dwl = super.dwl.overrideAttrs (old: {
            patches = (old.patches or [ ]) ++ [
              ../../patches/vanitygaps.patch
              ../../patches/dwl-config.patch
            ];
          });
        })
      ];
      home.packages = [ dwl ];
    };
}

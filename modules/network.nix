# SPDX-FileCopyrightText: 2023 Sam Nystrom <sam@samnystrom.dev>
# SPDX-License-Identifier: CC0-1.0

{ config, pkgs, ... }: {
  networking = {
    wireless = {
      enable = true;
      userControlled.enable = true;
      environmentFile = config.age.secrets."networks".path;
      networks = {
        "Yosemite 2".psk = "@HOME_PSK@";
        "Yosemite 5" = {
          psk = "@HOME_PSK@";
          priority = -1;
        };
        "wcs-visitor" = { };
      };
    };
  };
}

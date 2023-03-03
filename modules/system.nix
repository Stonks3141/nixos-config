{ config, pkgs, lib, ... }: {
  options.samn.system.stateVersion = lib.mkOption { type = lib.types.str; };

  config = {
    services.udev.extraRules = ''
      SUBSYSTEM=="usb", ATTR{idVendor}=="2207", ATTR{idProduct}=="0011", MODE="0660",
      GROUP="plugdev", SYMLINK+="android%n"
    '';

    security = {
      polkit.enable = true;
      rtkit.enable = true;
      pam.services.swaylock.text = ''
        auth include login
      '';
      doas = {
        enable = true;
        extraConfig = ''
          permit :wheel
        '';
      };
      sudo.enable = false;
    };

    services.printing.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };

    # Source: https://github.com/catppuccin/tty/blob/main/src/macchiato.sh
    #
    # Copyright (c) 2021 Catppuccin
    #
    # Permission is hereby granted, free of charge, to any person obtaining a copy
    # of this software and associated documentation files (the "Software"), to deal
    # in the Software without restriction, including without limitation the rights
    # to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    # copies of the Software, and to permit persons to whom the Software is
    # furnished to do so, subject to the following conditions:
    #
    # The above copyright notice and this permission notice shall be included in all
    # copies or substantial portions of the Software.
    console.colors = [
      "24273a"
      "5b6078"

      "cad3f5"
      "a5adcb"

      "ed8796"
      "ed8796"

      "a6da95"
      "a6da95"

      "eed49f"
      "eed49f"

      "8aadf4"
      "8aadf4"

      "f5bde6"
      "f5bde6"

      "8bd5ca"
      "8bd5ca"
    ];

    # services.openssh = {
    #   hostKeys = [
    #     {
    #       path = "~/.ssh/samn";
    #       type = "ed25519";
    #     }
    #     {
    #       path = "~/.ssh/pavilion";
    #       type = "ed25519";
    #     }
    #   ];
    # };

    programs.light.enable = true;
    programs.dconf.enable = true;
    programs.adb.enable = true;

    virtualisation.virtualbox.host.enable = true;
    virtualisation.docker.enable = true;

    users = {
      mutableUsers = false;
      users.samn = {
        isNormalUser = true;
        home = "/home/samn";
        description = "Sam Nystrom";
        uid = 1000;
        shell = pkgs.nushell;
        extraGroups = [ "wheel" "video" "audio" "kvm" "adbusers" "vboxusers" "plugdev" "docker" ];
        passwordFile = config.age.secrets."passwords/users/samn".path;
      };
    };

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = config.samn.system.stateVersion; # Did you read the comment?
  };
}


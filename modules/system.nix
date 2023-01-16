{ config, pkgs, lib, ... }: {
  options.samn.system = {
    stateVersion = lib.mkOption { type = lib.types.str; };
    wireguard.enable = lib.mkEnableOption "wireguard";
  };

  config = {
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    networking = {
      wireless = {
        enable = true;
        environmentFile = config.age.secrets."networks".path;
        networks = {
          "Yosemite 2".psk = "@HOME_PSK@";
          "Yosemite 5".psk = "@HOME_PSK@";
          "wcs-visitor" = { };
        };
      };
      firewall = {
        allowedTCPPorts = [ 53 ];
        allowedUDPPorts = [ 53 51820 ];
      };
      wireguard.interfaces = lib.mkIf config.samn.system.wireguard.enable {
        wg0 = rec {
          ips = [ "10.8.0.2/24" ];
          listenPort = 51820;
          privateKeyFile = config.age.secrets."wireguard/pavilion.key".path;
          interfaceNamespace = "wireguard";
          preSetup = ''
            ${pkgs.iproute2}/bin/ip netns add ${interfaceNamespace}
          '';
          postShutdown = ''
            ${pkgs.iproute2}/bin/ip netns del ${interfaceNamespace}
          '';
          peers = [
            {
              publicKey = "KRPqCHDSme92ehGS/Pm+/4KosU2jVvttuP95/hCVN10=";
              allowedIPs = [ "0.0.0.0/0" ];
              endpoint = "170.187.182.181:51820";
            }
          ];
        };
      };
    };

    services.dnsmasq = {
      enable = true;
      settings.server = [ "172.105.6.5" "172.105.9.5" "172.105.8.5" ];
      settings.interface = "wg0";
    };

    security = {
      polkit.enable = true;
      rtkit.enable = true;
      pam.services.swaylock.text = ''
        auth include login
      '';
      sudo = {
        extraRules = [
          {
            groups = [ "wheel" ];
            commands = [
              { command = "${pkgs.iproute2}/bin/ip netns exec *"; options = [ "SETENV" "NOPASSWD" ]; }
            ];
          }
        ];
        extraConfig = ''
          Defaults       timestamp_timeout=10
        '';
      };
    };

    services.printing.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };

    hardware.opentabletdriver.enable = true;

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

    users.mutableUsers = false;
    users.users.samn = {
      isNormalUser = true;
      home = "/home/samn";
      description = "Sam Nystrom";
      shell = pkgs.nushell;
      extraGroups = [ "wheel" "networkmanager" "video" "audio" "kvm" ];
      passwordFile = config.age.secrets."passwords/users/samn".path;
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

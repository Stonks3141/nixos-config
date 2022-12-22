{ config, pkgs, lib, ... }: {
  options.samn.system = {
    stateVersion = lib.mkOption { type = lib.types.str; };
    wireguard.enable = lib.mkEnableOption "wireguard";
  };

  config = {
    networking = {
      hostName = "samn-nixos";
      wireless.enable = true;
      firewall = {
        allowedTCPPorts = [ 53 ];
        allowedUDPPorts = [ 53 51820 ];
      };
      wireguard.interfaces = lib.mkIf config.samn.system.wireguard.enable {
        wg0 = rec {
          ips = [ "10.8.0.2/24" ];
          listenPort = 51820;
          privateKeyFile = "/home/samn/.wireguard/private.key";
          interfaceNamespace = "wireguard";
          preSetup = ''
            ${pkgs.iproute2}/bin/ip netns add ${interfaceNamespace}
          '';
        };
      };
    };

    # services.dnsmasq = {
    #   enable = true;
    #   settings.interface = "wg0";
    # };

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

    programs.light.enable = true;
    programs.dconf.enable = true;

    users.mutableUsers = false;
    users.users.samn = {
      isNormalUser = true;
      home = "/home/samn";
      description = "Sam Nystrom";
      shell = pkgs.nushell;
      extraGroups = [ "wheel" "networkmanager" "video" "audio" "kvm" ];
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

{ config, pkgs, lib, ... }:
let
  cfg = config.samn.network;
in
{
  options.samn.network.wireguard = {
    enable = lib.mkEnableOption "wireguard";
    privateKeyFile = lib.mkOption {
      type = lib.types.path;
      description = "Private key file for wireguard";
    };
  };

  config = {
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
      firewall = {
        allowedTCPPorts = [ 53 ];
        allowedUDPPorts = [ 53 51820 ];
      };
      wireguard.interfaces = lib.mkIf cfg.wireguard.enable {
        wg0 = rec {
          ips = [ "10.8.0.2/24" ];
          listenPort = 51820;
          privateKeyFile = cfg.wireguard.privateKeyFile;
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
  };
}

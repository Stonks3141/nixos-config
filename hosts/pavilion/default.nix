{ ... }: {
  imports = [ ./hardware.nix ];

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  networking.hostId = "95833b11";

  samn = {
    system = {
      stateVersion = "22.11";
      wireguard.enable = true;
    };
  };
}

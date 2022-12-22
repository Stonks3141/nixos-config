{ pkgs, ... }: {
  imports = [ ./hardware.nix ];

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  networking.hostId = "95833b11";
  networking.hostName = "pavilion";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
    
  boot.kernelParams = [ "i915.force_probe=46a6" ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware.opengl = {
    enable = true;
    driSupport = true;
    extraPackages = [ pkgs.intel-compute-runtime ];
  };

  samn = {
    system = {
      stateVersion = "22.11";
      wireguard.enable = true;
    };
  };
}

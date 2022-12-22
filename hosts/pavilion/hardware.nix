{ pkgs, ... }: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
    
  boot.kernelParams = [ "i915.force_probe=46a6" ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware.opengl = {
    enable = true;
    driSupport = true;
    extraPackages = [ pkgs.intel-compute-runtime ];
  };
}

{ config, pkgs, lib, ... }: rec {
  imports = [
    ./hardware-configuration.nix
    <home-manager/nixos>
    ./modules
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  boot.kernelParams = [ "i915.force_probe=46a6" ];

  networking = {
    hostName = "samn-nixos";
    wireless.enable = true;
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    extraPackages = [ pkgs.intel-compute-runtime ];
  };

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  security = {
    polkit.enable = true;
    pam.services.swaylock.text = ''
      auth include login
    '';
    sudo.extraConfig = ''
      Defaults       timestamp_timeout=10
    '';
  };

  services.printing.enable = true;

  sound.enable = true;
  programs.light.enable = true;
  programs.dconf.enable = true;

  samn = {
    stateVersion = system.stateVersion;
    desktop = {
      bgImage = "/home/samn/mountain.png";
      baseColor = "24273a";
      accentColor = "ed8796";
      gtkTheme = {
        package = pkgs.catppuccin-gtk;
        name = "Catppuccin-Red-Dark";
      };
      iconTheme = {
        package = pkgs.papirus-icon-theme;
        name = "Papirus-Dark";
      };
      cursorTheme = {
        package = pkgs.catppuccin-cursors.macchiatoDark;
        name = "Catppuccin-Macchiato-Dark-Cursors";
      };
    };
  };

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
  system.stateVersion = "22.11"; # Did you read the comment?
}

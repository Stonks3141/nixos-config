{ pkgs, lib, ... }:
let
  nur = pkgs.nur;
in
{
  imports = [
    ./nushell
    ./bat.nix
    ./kitty.nix
    ./helix.nix
    ./bottom.nix
    ./gitui.nix
  ];

  samn.applications = {
    bat.enable = lib.mkDefault true;
    kitty.enable = lib.mkDefault true;
    helix.enable = lib.mkDefault true;
    bottom.enable = lib.mkDefault true;
    gitui.enable = lib.mkDefault true;
  };

  home-manager.users.samn = { pkgs, ... }: {
    home.packages = with pkgs; [
      # Prompt
      starship

      # CLIs
      ripgrep
      zoxide
      exa
      fd
      fzf
      mdcat
      tokei
      zip
      unzip
      appimage-run

      # GUI applications
      xfce.thunar
      xfce.tumbler # thumbnails for Thunar
      viewnior
      # libreoffice
      vlc
      discord
      android-studio
      prusa-slicer
      (tor-browser-bundle-bin.override {
        useHardenedMalloc = false;
      })
    ];

    programs.firefox = {
      enable = true;
      extensions = with nur.repos.rycee.firefox-addons; [
        ublock-origin
        bitwarden
        firefox-color
        stylus
      ];
    };

    programs.git = {
      enable = true;
      userEmail = "samuel.l.nystrom@gmail.com";
      userName = "Sam Nystrom";
    };

    programs.gpg = {
      enable = true;
      mutableKeys = false;
    };
  };
}

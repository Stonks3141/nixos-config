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

    home.sessionVariables = {
      FZF_DEFAULT_OPTS = "--color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 --color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 --color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796";
    };

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

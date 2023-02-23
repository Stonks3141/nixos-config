{ pkgs, lib, ... }: {
  imports = [
    ./nushell
    ./bat.nix
    ./kitty.nix
    ./helix.nix
    ./bottom.nix
    ./gitui.nix
    ./aerc.nix
    ./starship.nix
    ./firefox.nix
  ];

  samn.applications = {
    bat.enable = lib.mkDefault true;
    kitty.enable = lib.mkDefault true;
    helix.enable = lib.mkDefault true;
    bottom.enable = lib.mkDefault true;
    gitui.enable = lib.mkDefault true;
    starship.enable = lib.mkDefault true;
    firefox.enable = lib.mkDefault true;
  };

  home-manager.users.samn = { pkgs, ... }: {
    home.packages = with pkgs; [
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
      jetbrains.idea-community
      prusa-slicer
    ];

    home.sessionVariables = {
      FZF_DEFAULT_OPTS = "--color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 --color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 --color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796";
    };

    programs.git = rec {
      enable = true;
      package = pkgs.gitFull;
      userEmail = "samuel.l.nystrom@gmail.com";
      userName = "Sam Nystrom";
      extraConfig.sendemail = {
        smtpserver = "smtp.gmail.com";
        smtpuser = userEmail;
        smtpencryption = "tls";
        smtpserverport = 587;
      };
    };
  };
}

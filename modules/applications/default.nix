# SPDX-FileCopyrightText: 2022 Sam Nystrom <sam@samnystrom.dev>
# SPDX-License-Identifier: CC0-1.0

{ config, pkgs, lib, ... }: {
  imports = [
    ./nushell
    ./bat.nix
    ./foot.nix
    ./helix.nix
    ./bottom.nix
    ./gitui.nix
    ./aerc.nix
    ./starship.nix
    ./firefox.nix
  ];

  samn.applications = {
    bat.enable = lib.mkDefault true;
    foot.enable = lib.mkDefault true;
    helix.enable = lib.mkDefault true;
    bottom.enable = lib.mkDefault true;
    gitui.enable = lib.mkDefault true;
    starship.enable = lib.mkDefault true;
    firefox.enable = lib.mkDefault true;
  };

  environment.systemPackages = [ pkgs.git ];

  home-manager.users.samn = { pkgs, ... }: {
    home.packages = with pkgs; [
      ripgrep
      zoxide
      exa
      fd
      fzf
      tokei

      amfora
      nnn

      imv
      discord
      android-studio
    ];

    home.sessionVariables = {
      FZF_DEFAULT_OPTS = "--color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 --color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 --color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796";
    };

    programs.git =
      let
        email-creds = pkgs.writeScript "email-password-credentials" ''
          if [ "$1" = "get" ]; then
            echo "password=$(cat ${config.age.secrets."passwords/email/sam_at_samnystrom.dev".path})"
          fi
        '';
      in
      rec {
        enable = true;
        package = pkgs.gitFull;
        userEmail = "sam@samnystrom.dev";
        userName = "Sam Nystrom";
        extraConfig = {
          sendemail = {
            verify = "off";
            annotate = "yes";
            smtpServer = "smtp.migadu.com";
            smtpUser = userEmail;
            smtpEncryption = "tls";
            smtpServerPort = 587;
          };
          credential."smtp://sam%40samnystrom.dev@smtp.migadu.com:587".helper = "${email-creds}";
        };
      };
  };
}

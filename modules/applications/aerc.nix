{ config, pkgs, lib, ... }: {
  home-manager.users.samn = { pkgs, ... }: {
    accounts.email.accounts."samuel.l.nystrom@gmail.com"= {
      primary = true;
      flavor = "gmail.com";
      address = "samuel.l.nystrom@gmail.com";
      realName = "Sam Nystrom";
      passwordCommand = "cat ${config.age.secrets."passwords/email/samuel.l.nystrom_at_gmail.com".path}";
      aerc.enable = true;
      # notmuch.enable = true;
    };
    programs.aerc = {
      enable = true;
      extraConfig = {
        general.unsafe-accounts-conf = true;
        compose.editor = "${pkgs.helix}/bin/hx";
      };
    };
  };
}

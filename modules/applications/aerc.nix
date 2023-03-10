# SPDX-FileCopyrightText: 2023 Sam Nystrom <sam@samnystrom.dev>
# SPDX-License-Identifier: CC0-1.0

{ config, pkgs, lib, ... }: {
  home-manager.users.samn = { pkgs, ... }: {
    accounts.email.accounts."sam@samnystrom.dev" = rec {
      primary = true;
      address = "sam@samnystrom.dev";
      userName = address;
      realName = "Sam Nystrom";
      passwordCommand = "cat ${config.age.secrets."passwords/email/sam_at_samnystrom.dev".path}";
      imap = {
        host = "imap.migadu.com";
        port = 993;
      };
      smtp = {
        host = "smtp.migadu.com";
        port = 465;
      };
      signature = {
        showSignature = "append";
        text = "Sam";
      };
      aerc.enable = true;
      # TODO: mbsync/postfix?
    };

    programs.aerc = {
      enable = true;

      extraConfig = {
        general.unsafe-accounts-conf = true;
        compose.editor = "${pkgs.helix}/bin/hx";
        viewer.pager = "less -R";
        filters = {
          "text/plain" = "colorize";
          "text/calendar" = "calendar";
          "message/delivery-status" = "colorize";
          "message/rfc822" = "colorize";
        };
      };

      # stylesets.default = {
      #   
      # };

      extraBinds = ''
        # Binds are of the form <key sequence> = <command to run>
        # To use '=' in a key sequence, substitute it with "Eq": "<Ctrl+Eq>"
        # If you wish to bind #, you can wrap the key sequence in quotes: "#" = quit
        <C-p> = :prev-tab<Enter>
        <C-n> = :next-tab<Enter>
        <C-t> = :term<Enter>
        ? = :help keys<Enter>
        
        [messages]
        q = :quit<Enter>
        
        j = :next<Enter>
        <Down> = :next<Enter>
        <C-d> = :next 50%<Enter>
        <C-f> = :next 100%<Enter>
        <PgDn> = :next 100%<Enter>
        
        k = :prev<Enter>
        <Up> = :prev<Enter>
        <C-u> = :prev 50%<Enter>
        <C-b> = :prev 100%<Enter>
        <PgUp> = :prev 100%<Enter>
        g = :select 0<Enter>
        G = :select -1<Enter>
        
        J = :next-folder<Enter>
        K = :prev-folder<Enter>
        H = :collapse-folder<Enter>
        L = :expand-folder<Enter>
        
        v = :mark -t<Enter>
        V = :mark -v<Enter>
        
        T = :toggle-threads<Enter>
        
        <Enter> = :view<Enter>
        d = :prompt 'Really delete this message?' 'delete-message'<Enter>
        D = :delete<Enter>
        A = :archive flat<Enter>
        
        C = :compose<Enter>
        
        rr = :reply -a<Enter>
        rq = :reply -aq<Enter>
        Rr = :reply<Enter>
        Rq = :reply -q<Enter>
        
        c = :cf<space>
        $ = :term<space>
        ! = :term<space>
        | = :pipe<space>
        
        / = :search<space>
        \ = :filter<space>
        n = :next-result<Enter>
        N = :prev-result<Enter>
        <Esc> = :clear<Enter>
        
        [messages:folder=Drafts]
        <Enter> = :recall<Enter>
        
        [view]
        / = :toggle-key-passthrough<Enter>/
        q = :close<Enter>
        O = :open<Enter>
        S = :save<space>
        | = :pipe<space>
        D = :delete<Enter>
        A = :archive flat<Enter>
        
        <C-l> = :open-link <space>
        
        f = :forward<Enter>
        rr = :reply -a<Enter>
        rq = :reply -aq<Enter>
        Rr = :reply<Enter>
        Rq = :reply -q<Enter>
        
        H = :toggle-headers<Enter>
        <C-k> = :prev-part<Enter>
        <C-j> = :next-part<Enter>
        J = :next<Enter>
        K = :prev<Enter>
        
        [view::passthrough]
        $noinherit = true
        $ex = <C-x>
        <Esc> = :toggle-key-passthrough<Enter>
        
        [compose]
        # Keybindings used when the embedded terminal is not selected in the compose
        # view
        $noinherit = true
        $ex = <C-x>
        <C-k> = :prev-field<Enter>
        <C-j> = :next-field<Enter>
        <A-p> = :switch-account -p<Enter>
        <A-n> = :switch-account -n<Enter>
        <tab> = :next-field<Enter>
        <backtab> = :prev-field<Enter>
        <C-p> = :prev-tab<Enter>
        <C-n> = :next-tab<Enter>
        
        [compose::editor]
        # Keybindings used when the embedded terminal is selected in the compose view
        $noinherit = true
        $ex = <C-x>
        <C-k> = :prev-field<Enter>
        <C-j> = :next-field<Enter>
        <C-p> = :prev-tab<Enter>
        <C-n> = :next-tab<Enter>
        
        [compose::review]
        # Keybindings used when reviewing a message to be sent
        y = :send<Enter>
        n = :abort<Enter>
        v = :preview<Enter>
        p = :postpone<Enter>
        q = :choose -o d discard abort -o p postpone postpone<Enter>
        e = :edit<Enter>
        a = :attach<space>
        d = :detach<space>
        
        [terminal]
        $noinherit = true
        $ex = <C-x>
        
        <C-p> = :prev-tab<Enter>
        <C-n> = :next-tab<Enter>
      '';
    };
  };
}

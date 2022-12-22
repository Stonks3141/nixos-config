{ ... }: {
  imports = [ ./nushell ];

  home-manager.users.samn = { pkgs, ... }: {
    home.packages = with pkgs; [
      # Prompt
      starship

      # CLIs
      ripgrep
      bat
      bottom
      zoxide
      zip
      unzip

      # GUIs
      xfce.thunar
      xfce.tumbler # thumbnails for Thunar
      viewnior
      libreoffice
      vlc
      discord
    ];
    
    programs.firefox = {
      enable = true;
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        bitwarden
      ];
    };

    programs.kitty = {
      enable = true;
      font = {
        package = (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; });
        name = "FiraCode Nerd Font";
        size = 10;
      };
      theme = "Catppuccin-Macchiato";
      settings = {
        background_opacity = "0.9";
        enable_audio_bell = false;
      };
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

    programs.helix = {
      enable = true;
      settings = {
        theme = "my_catppuccin_macchiato";
        editor = {
          gutters = [ "diagnostics" "spacer" "line-numbers" "spacer" "diff" ];
          bufferline = "multiple";
          mouse = false;
          indent-guides.render = true;
        };
      };
      themes.my_catppuccin_macchiato = {
        inherits = "catppuccin_macchiato";
        hint.fg = "white";
        info.fg = "blue";
        warning.fg = "orange";
        error.fg = "red";
        "diagnostic.hint".underline = { style = "curl"; color = "white"; };
        "diagnostic.info".underline = { style = "curl"; color = "blue"; };
        "diagnostic.warning".underline = { style = "curl"; color = "orange"; };
        "diagnostic.error".underline = { style = "curl"; color = "red"; };
      };
    };
  };
}

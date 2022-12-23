{ pkgs, ... }:
let
  nur = pkgs.nur;
in
{
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
      extensions = with nur.repos.rycee.firefox-addons; [
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

    programs.gitui = {
      enable = true;
      keyConfig = ''
        (
          focus_left: Some(( code: Char('h'), modifiers: ( bits: 0,),)),
          focus_below: Some(( code: Char('j'), modifiers: ( bits: 0,),)),
          focus_above: Some(( code: Char('k'), modifiers: ( bits: 0,),)),
          focus_right: Some(( code: Char('l'), modifiers: ( bits: 0,),)),
          
          move_left: Some(( code: Char('h'), modifiers: ( bits: 0,),)),
          move_down: Some(( code: Char('j'), modifiers: ( bits: 0,),)),
          move_up: Some(( code: Char('k'), modifiers: ( bits: 0,),)),
          move_right: Some(( code: Char('l'), modifiers: ( bits: 0,),)),
      
          open_help: Some(( code: F(1), modifiers: ( bits: 0,),)),
        )
      '';
      theme = ''
        /*
        Copyright (c) 2021 Catppuccin

        Permission is hereby granted, free of charge, to any person obtaining a copy
        of this software and associated documentation files (the "Software"), to deal
        in the Software without restriction, including without limitation the rights
        to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
        copies of the Software, and to permit persons to whom the Software is
        furnished to do so, subject to the following conditions:
        
        The above copyright notice and this permission notice shall be included in all
        copies or substantial portions of the Software.
        */
        (
          selected_tab: Reset,
          command_fg: Rgb(202, 211, 245),
          selection_bg: Rgb(91, 96, 120),
          selection_fg: Rgb(202, 211, 245),
          cmdbar_bg: Rgb(30, 32, 48),
          cmdbar_extra_lines_bg: Rgb(30, 32, 48),
          disabled_fg: Rgb(128, 135, 162),
          diff_line_add: Rgb(166, 218, 149),
          diff_line_delete: Rgb(237, 135, 150),
          diff_file_added: Rgb(238, 212, 159),
          diff_file_removed: Rgb(238, 153, 160),
          diff_file_moved: Rgb(198, 160, 246),
          diff_file_modified: Rgb(245, 169, 127),
          commit_hash: Rgb(183, 189, 248),
          commit_time: Rgb(184, 192, 224),
          commit_author: Rgb(125, 196, 228),
          danger_fg: Rgb(237, 135, 150),
          push_gauge_bg: Rgb(138, 173, 244),
          push_gauge_fg: Rgb(36, 39, 58),
          tag_fg: Rgb(244, 219, 214),
          branch_fg: Rgb(139, 213, 202)
        )
      '';
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

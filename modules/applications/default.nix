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
  ];

  samn.applications = {
    bat.enable = lib.mkDefault true;
    kitty.enable = lib.mkDefault true;
    helix.enable = lib.mkDefault true;
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
        Source: https://github.com/catppuccin/gitui/blob/master/theme/macchiato.ron

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

    programs.bottom = {
      enable = true;
      settings.colors = {
        # Source: https://github.com/catppuccin/bottom/blob/main/themes/macchiato.toml
        #
        # Copyright (c) 2021 Catppuccin
        #
        # Permission is hereby granted, free of charge, to any person obtaining a copy
        # of this software and associated documentation files (the "Software"), to deal
        # in the Software without restriction, including without limitation the rights
        # to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
        # copies of the Software, and to permit persons to whom the Software is
        # furnished to do so, subject to the following conditions:
        #
        # The above copyright notice and this permission notice shall be included in all
        # copies or substantial portions of the Software.

        table_header_color = "#f4dbd6";
        all_cpu_color = "#f4dbd6";
        avg_cpu_color = "#ee99a0";
        cpu_core_colors = [ "#ed8796" "#f5a97f" "#eed49f" "#a6da95" "#7dc4e4" "#c6a0f6" ];
        ram_color = "#a6da95";
        swap_color = "#f5a97f";
        rx_color = "#a6da95";
        tx_color = "#ed8796";
        widget_title_color = "#f0c6c6";
        border_color = "#5b6078";
        highlighted_border_color = "#f5bde6";
        text_color = "#cad3f5";
        graph_color = "#a5adcb";
        cursor_color = "#f5bde6";
        selected_text_color = "#181926";
        selected_bg_color = "#c6a0f6";
        high_battery_color = "#a6da95";
        medium_battery_color = "#eed49f";
        low_battery_color = "#ed8796";
        gpu_core_colors = [ "#7dc4e4" "#c6a0f6" "#ed8796" "#f5a97f" "#eed49f" "#a6da95" ];
        arc_color = "#91d7e3";
      };
    };

    programs.gpg = {
      enable = true;
      mutableKeys = false;
    };
  };
}

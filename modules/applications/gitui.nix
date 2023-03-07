# SPDX-FileCopyrightText: 2023 Sam Nystrom <sam@samnystrom.dev>
# SPDX-License-Identifier: CC0-1.0

{ config, lib, ... }:
let
  cfg = config.samn.applications.gitui;
in
{
  options.samn.applications.gitui = {
    enable = lib.mkEnableOption "gitui";
    catppuccin = lib.mkOption {
      type = lib.types.enum [ "mocha" "macchiato" "frappe" "latte" ];
      default = config.samn.catppuccin;
      description = "Catppuccin flavor for gitui";
    };
  };

  config.home-manager.users.samn = { pkgs, ... }: {
    programs.gitui = lib.mkIf cfg.enable {
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
      theme = builtins.readFile (pkgs.fetchFromGitHub
        {
          owner = "catppuccin";
          repo = "gitui";
          rev = "ff1e802cfff3d5ff41b0d829a3df1da8087b1265";
          sha256 = "sha256-frkGtsk/VuS6MYUf7S2hqNHhTaV6S0Mv2UuttCgvimk=";
        } + /theme/${cfg.catppuccin}.ron);
    };
  };
}

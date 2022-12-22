{ ... }: {
  home-manager.users.samn = { ... }: {
    programs.rofi = {
      enable = true;
      font = "FiraCode Nerd Font 12";
      terminal = "kitty";
      theme = ./catppuccin-macchiato.rasi;
    };
  };
}

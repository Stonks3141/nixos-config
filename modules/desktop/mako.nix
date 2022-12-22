{ config, ... }: {
  home-manager.users.samn = { ... }: {
    programs.mako = {
      enable = true;
      backgroundColor = "#${config.samn.desktop.baseColor}ff";
      borderColor = "#${config.samn.desktop.accentColor}ff";
      font = "FiraCode Nerd Font 10";
      borderSize = 2;
      margin = "20";
    };
  };
}

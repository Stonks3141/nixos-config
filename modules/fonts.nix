{ pkgs, ... }: {
  config.fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
    noto-fonts
  ];
}

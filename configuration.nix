{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    <home-manager/nixos>
    ./modules
  ];

  samn = {
    system = {
      stateVersion = "22.11";
      wireguard.enable = true;
    };
    desktop = {
      bgImage = "/home/samn/mountain.png";
      baseColor = "24273a";
      accentColor = "ed8796";
      gtkTheme = {
        package = pkgs.catppuccin-gtk;
        name = "Catppuccin-Red-Dark";
      };
      iconTheme = {
        package = pkgs.papirus-icon-theme;
        name = "Papirus-Dark";
      };
      cursorTheme = {
        package = pkgs.catppuccin-cursors.macchiatoDark;
        name = "Catppuccin-Macchiato-Dark-Cursors";
      };
    };
  };
}

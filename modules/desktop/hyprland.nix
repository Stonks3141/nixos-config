{ config, lib, pkgs, ... }: {
  home-manager.users.samn = { pkgs, ... }: {
    wayland.windowManager.hyprland = {
      enable = true;
    };
  };
}

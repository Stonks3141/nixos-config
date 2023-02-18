{ config, lib, pkgs, ... }: {
  services.greetd =
    let
      gtkTheme = config.home-manager.users.samn.gtk.theme;
      hyprConfig = pkgs.writeText "hypr-config"
        ''
          source=/home/samn/.config/hypr/hyprland.conf
          exec-once=${pkgs.greetd.gtkgreet}/bin/gtkgreet \
            -l \
            -c "${if config.samn.network.wireguard.enable then
              "sudo -E ${pkgs.iproute2}/bin/ip netns exec wireguard sudo -E -u #${builtins.toString config.users.users.samn.uid} "
              else ""}Hyprland" \
            -s ${gtkTheme.package}/share/themes/${gtkTheme.name}/gtk-3.0/gtk-dark.css; \
            hyprctl dispatch exit
        '';
    in
    {
      enable = true;
      restart = true;
      settings = {
        default_session = {
          command = "Hyprland --config ${hyprConfig}";
        };
      };
    };
}
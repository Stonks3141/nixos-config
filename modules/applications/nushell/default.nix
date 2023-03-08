# SPDX-FileCopyrightText: 2022 Sam Nystrom <sam@samnystrom.dev>
# SPDX-License-Identifier: CC0-1.0

{ config, ... }: {
  home-manager.users.samn = {
    programs.nushell = {
      enable = true;
      configFile.source = ./config.nu;
      envFile.source = ./env.nu;
      extraEnv = with builtins; concatStringsSep
        "\n"
        (attrValues
          (mapAttrs
            (name: value: "let-env ${name} = '${value}'")
            config.home-manager.users.samn.home.sessionVariables));
    };
  };
}

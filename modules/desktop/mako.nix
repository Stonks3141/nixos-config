{ config, ... }: {
  home-manager.users.samn = { ... }: {
    programs.mako = {
      enable = true;
      font = "FiraCode Nerd Font 10";
      borderSize = 2;
      borderRadius = 3;
      margin = "20";

      # Source: https://github.com/catppuccin/mako/blob/main/src/macchiato
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
      backgroundColor = "#24273aff";
      textColor = "#cad3f5ff";
      borderColor = "#8aadf4ff";
      extraConfig = ''
        progress-color=over #363a4f
        [urgency=high]
        border-color=#f5a97f
      '';
    };
  };
}

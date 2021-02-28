{ config, pkgs, ... }:

{
  services = {
    spacebar = {
      package = pkgs.spacebar;
      config = {
        position = "top";
        height = 26;
        text_font = ''"Fira Code:Retina:15"'';
      };
    };

    yabai = {
      config = {
        external_bar = "all:26:0";
      };
    };

  };
  fonts = {
    enableFontDir = true;
    fonts = [
      pkgs.fira-code
    ];
  };
}

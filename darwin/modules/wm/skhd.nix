{ config, pkgs, ... }:

{
  services = {
    skhd = {
      package = pkgs.skhd;
      skhdConfig = ''
        # move window
        shift + cmd - h : yabai -m window --warp west  || yabai -m window --display west
        shift + cmd - j : yabai -m window --warp south || yabai -m window --display south
        shift + cmd - k : yabai -m window --warp north || yabai -m window --display north
        shift + cmd - l : yabai -m window --warp east  || yabai -m window --display east

        # toggle split
        shift + alt - space : yabai -m window --toggle split

        # rebalance space
        shift + cmd - space  : yabai -m space --balance

        # toggle fullscreen
        shift + cmd - return : yabai -m window --toggle zoom-fullscreen

        # open terminal
        # alt - return         : open -a kitty
      '';
    };
  };
}

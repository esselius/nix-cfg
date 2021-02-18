{ config, pkgs, ... }:

{
  services = {
    yabai = {
      enable = true;
      package = pkgs.yabai;
      enableScriptingAddition = false;

      config = {
        layout                = "bsp";

        top_padding           = "10";
        bottom_padding        = "10";
        left_padding          = "10";
        right_padding         = "10";
        window_gap            = "10";

        auto_balance          = "on";
        focus_follows_mouse   = "autofocus";

        mouse_modifier        = "alt";
        mouse_action1         = "resize";
        mouse_drop_action     = "swap";
      };

      extraConfig = ''
        yabai -m rule --add app="^System Preferences$" manage=off
        yabai -m rule --add app="^Activity Monitor$" manage=off sticky=on layer=above
        yabai -m rule --add app="^Viscosity$" manage=off
        yabai -m rule --add app="^Intel Power Gadget$" manage=off
      '';
    };

    skhd = {
      enable = true;
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
        alt - return         : open -a kitty
      '';
    };
  };

  system.defaults = {
    NSGlobalDomain = {
      _HIHideMenuBar = true;
    };
    finder = {
      CreateDesktop = false;
    };
  };

  system.stateVersion = 4;
}

{ config, pkgs, ... }:

{
  services = {
    yabai = {
      package = pkgs.yabai;
      enableScriptingAddition = false;

      config = {
        layout = "bsp";

        top_padding = "10";
        bottom_padding = "10";
        left_padding = "10";
        right_padding = "10";
        window_gap = "10";

        auto_balance = "on";
        focus_follows_mouse = "autofocus";

        mouse_modifier = "alt";
        mouse_action1 = "resize";
        mouse_drop_action = "swap";
      };

      extraConfig = ''
        yabai -m rule --add app="^System Preferences$" manage=off
        yabai -m rule --add app="^Activity Monitor$" manage=off sticky=on layer=above
        yabai -m rule --add app="^Viscosity$" manage=off
        yabai -m rule --add app="^Intel Power Gadget$" manage=off
        yabai -m rule --add app="^Screen$" manage=off
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
}

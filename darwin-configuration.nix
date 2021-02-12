{ config, pkgs, ... }:

{
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
    trustedUsers = [ "root" "@admin" ];
  };

  services = {
    nix-daemon.enable = true;

    yabai = {
      enable = true;
      package = pkgs.yabai;
      enableScriptingAddition = false;

      config = {
        focus_follows_mouse = "autofocus";
      };

      extraConfig = ''
        yabai -m rule --add app="^System Preferences$" manage=off
        yabai -m rule --add app="^Activity Monitor$" manage=off sticky=on layer=above
        yabai -m rule --add app="^Viscosity$" manage=off
        yabai -m rule --add app="^Intel Power Gadget$" manage=off
        yabai -m rule --add app="^Screen$" manage=off
      '';
    };

    skhd = {
      enable = true;
      package = pkgs.skhd;
      skhdConfig = ''
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

  programs = {
    zsh.enable = true;
    fish = {
      enable = true;
      useBabelfish = true;
      babelfishPackage = pkgs.babelfish;

      shellInit = ''
        source /etc/fish/nixos-env-preinit.fish
      '';
    };

    gnupg = {
      agent = {
        enable = true;
        enableSSHSupport = true;
      };
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

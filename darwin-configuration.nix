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
      enableScriptingAddition = true;

      config = {
        focus_follows_mouse = "autofocus";
        window_topmost = "on";
      };

      extraConfig = ''
        yabai -m rule --add app="^System Preferences$" manage=off
        yabai -m rule --add app="^Viscosity$" manage=off
        yabai -m rule --add app="^Screen$" manage=off
      '';
    };

    skhd = {
      enable = true;
      package = pkgs.skhd;
      skhdConfig = ''
        # rebalance space
        cmd + shift - return : yabai -m space --balance

        # toggle fullscreen
        cmd - return         : yabai -m window --toggle zoom-fullscreen

        # toggle split
        alt + shift - return : yabai -m window --toggle split

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

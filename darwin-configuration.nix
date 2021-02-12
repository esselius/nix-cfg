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
        focus_follows_mouse = "off";

        layout = "bsp";
      };
    };

    skhd = {
      enable = true;
      package = pkgs.skhd;
      skhdConfig = ''
        # move window
        ctrl + alt - left : yabai -m window --warp west
        ctrl + alt - down : yabai -m window --warp south
        ctrl + alt - up : yabai -m window --warp north
        ctrl + alt - right : yabai -m window --warp east

        # open terminal
        cmd - return : open -a kitty
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

  system.defaults.finder = {
    CreateDesktop = false;
  };

  system.stateVersion = 4;
}
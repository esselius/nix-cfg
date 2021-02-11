{ config, pkgs, ... }:

{
  services.nix-daemon.enable = true;

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
    trustedUsers = [ "root" "@admin" ];
  };

  programs.zsh.enable = true;
  programs.fish = {
    enable = true;
    useBabelfish = true;
    babelfishPackage = pkgs.babelfish;

    shellInit = ''
      source /etc/fish/nixos-env-preinit.fish
    '';
  };

  programs.gnupg = {
    agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  system.stateVersion = 4;
}
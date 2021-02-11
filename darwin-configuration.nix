{ config, pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.vim
    pkgs.git
  ];

  services.nix-daemon.enable = true;

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
    trustedUsers = ["@admin"];
  };

  programs.zsh.enable = true;

  system.stateVersion = 4;
}
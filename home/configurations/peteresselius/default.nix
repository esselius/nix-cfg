{ pkgs, ... }:

{
  imports = import ../../modules;

  programs.fish.enable = true;
  programs.starship.enable = true;
  programs.kitty.enable = true;

  home.packages = with pkgs; [
    nixpkgs-fmt
    cmatrix
    google-cloud-sdk
    sbt
    cowsay
    viscosity-sh
    qemu
    ghq
    sops
    jq
    yq
    fzf
    socat
    pv
    hub
    ripgrep
    bfg-repo-cleaner
    vault
    stern
    chromedriver
    vim
    # log4brains
  ];

  home.sessionVariables = {
    EDITOR = "vim";
  };
}

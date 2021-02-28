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
    nodejs
    viscosity-sh
    qemu
  ];
}

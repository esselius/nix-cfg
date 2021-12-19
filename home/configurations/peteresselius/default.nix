{ pkgs, ... }:

{
  imports = import ../../modules;

  programs.fish.enable = true;
  programs.starship.enable = true;
  programs.kitty.enable = true;

  home.packages = with pkgs; [
    nixpkgs-fmt
    cmatrix
    # google-cloud-sdk
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
    dhall-lsp-server
    dhall
    # log4brains
    ruby
    etcdctl
    deno
    scalafmt
    git-quick-stats
    # jetbrains.idea-ultimate
    # firefox
    # jdk
    unzip
    gnupg
    gh
    ngrok
  ];

}

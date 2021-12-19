{ pkgs, ... }:

{
  programs.fish.enable = true;

  users.users.vagrant.shell = pkgs.fish;
}

{ pkgs, ... }:

{
  programs.fish = {
    enable = true;
    useBabelfish = true;
    babelfishPackage = pkgs.babelfish;

    shellInit = ''
      source /etc/fish/nixos-env-preinit.fish
    '';
  };
}

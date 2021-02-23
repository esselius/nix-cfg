{ pkgs, ... }:

{
  programs.fish = {
    useBabelfish = true;
    babelfishPackage = pkgs.babelfish;

    shellInit = ''
      source /etc/fish/nixos-env-preinit.fish
    '';
  };
}

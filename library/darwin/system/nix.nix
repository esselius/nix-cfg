{ pkgs, ... }:

{
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
    trustedUsers = [ "root" "@admin" ];
  };

  services.nix-daemon.enable = true;
}
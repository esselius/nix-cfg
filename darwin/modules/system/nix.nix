{ pkgs, ... }:

{
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes ca-references";
    trustedUsers = [ "root" "@admin" ];
  };

  services.nix-daemon.enable = true;
  users.nix.configureBuildUsers = true;

  system.stateVersion = 4;
}

{ pkgs, ... }:

{
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes ca-references";
    trustedUsers = [ "root" "@admin" ];

    binaryCaches = [
      "https://cache.nixos.org"
      "https://esselius.cachix.org"
    ];

    binaryCachePublicKeys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "esselius.cachix.org-1:w6SK4Jb27KNtsewkVfmiFhVRERQ5WBnZ5H7pULvLxVg="
    ];
  };

  services.nix-daemon.enable = true;
  users.nix.configureBuildUsers = true;

  system.stateVersion = 4;
}

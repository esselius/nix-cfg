{ src, yarn2nix-moretea }:

(
  yarn2nix-moretea.mkYarnWorkspace {
    inherit src;
  }
).log4brains

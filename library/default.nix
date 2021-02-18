{ nixpkgs, darwin, dns-heaven, ... }:
let
  inherit (nixpkgs) lib;

  importModulesDir = dir:
    lib.fold lib.recursiveUpdate { } (map
      (path:
        lib.setAttrByPath
          (lib.pipe path [
            toString
            (lib.removePrefix "${toString dir}/")
            (lib.removeSuffix ".nix")
            (lib.strings.splitString "/")
          ])
          (import path))
      (lib.filesystem.listFilesRecursive dir));
in
{
  overlays = {
    switchScripts = (final: prev: {
      switchScripts = prev.callPackage ./switchScripts.nix { inherit darwin; };
    });
    packages = (final: prev: {
      dns-heaven = prev.callPackage ./pkgs/dns-heaven.nix { src = dns-heaven; };
    });
  };

  homeModules = importModulesDir ./home;
  darwinModules = importModulesDir ./darwin;
  nixosModules = importModulesDir ./nixos;
}

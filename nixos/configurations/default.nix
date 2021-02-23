{ self, nixpkgs, ... }:
{
  nixosConfigurations.nixbox = nixpkgs.lib.makeOverridable nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ./nixos/configuration.nix
    ];
  };
}
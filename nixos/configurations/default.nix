{ self, nixpkgs, home, ... }@inputs:
{
  nixbox = nixpkgs.lib.makeOverridable nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ./nixbox-vmware/configuration.nix

      {
        imports = [ home.nixosModules.home-manager ];

        home-manager.useGlobalPkgs = false;
        home-manager.useUserPackages = false;
        home-manager.backupFileExtension = "backup";

        home-manager.extraSpecialArgs = { inherit inputs; };

        home-manager.users.vagrant = import ../../home/configurations/peteresselius;
      }
    ];
  };
}

{ self, nixpkgs, home, ... }@inputs:
{
  nixbox = nixpkgs.lib.makeOverridable nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ./nixos/configuration.nix

      {
        users.users.peteresselius = {
          home = "/home/peteresselius";
          isNormalUser = true;
          extraGroups = ["wheel"];
        };
      }

      {
        imports = [ home.nixosModules.home-manager ];

        home-manager.useGlobalPkgs = false;
        home-manager.useUserPackages = false;
        home-manager.backupFileExtension = "backup";

        home-manager.extraSpecialArgs = { inherit inputs; };

        home-manager.users.peteresselius = import ../../home/configurations/peteresselius;
      }
    ];
  };
}

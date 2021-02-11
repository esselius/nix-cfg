{
  description = "Nix Config of Pepp";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home.url = "github:nix-community/home-manager";
  };

  outputs = { self, nixpkgs, darwin, home }: {
    darwinConfigurations.Pepps-MacBook-Pro = darwin.lib.darwinSystem {
      modules = [
        ./darwin-configuration.nix
        home.darwinModules.home-manager
        {
          home-manager.backupFileExtension = "backup";
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.peteresselius = import ./home.nix;
        }
      ];
    };

    packages.x86_64-darwin.nix-darwin-installer = self.darwinConfigurations.Pepps-MacBook-Pro.system;
  };
}
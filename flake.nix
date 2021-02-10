{
  description = "Nix Config of Pepp";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, darwin, nixpkgs }: {
    darwinConfigurations.Pepps-MacBook-Pro = darwin.lib.darwinSystem {
      modules = [ ./darwin-configuration.nix ];
    };
    packages.x86_64-darwin.nix-darwin-installer = self.darwinConfigurations.Vagrants-MacBook-Pro.system;
  };
}
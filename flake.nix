{
  description = "Nix Config of Pepp";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home.url = "github:nix-community/home-manager";
    flake-utils.url = "github:numtide/flake-utils";

    nix-library.url = "github:esselius/nix-library";
  };

  outputs = { self, nixpkgs, darwin, home, flake-utils, nix-library, ... }@inputs:
    let
      systems = [ "x86_64-linux" "x86_64-darwin" ];
      flake = flake-utils.lib.eachSystem systems
        (system:
          let
            pkgs = import nixpkgs {
              inherit system;
              overlays = [ nix-library.overlay ];
            };


            darwinConfig = username: darwin.lib.darwinSystem {
              modules = [
              ./darwin-configuration.nix
              home.darwinModules.home-manager
              nix-library.darwinModules.all
              nix-library.homeModules.all
              {
                home-manager.users.${username} = import ./home.nix;

                services.yubikey-agent.enable = true;
                services.yubikey-agent.package = pkgs.yubikey-agent;

                services.dns-heaven.enable = true;
                services.dns-heaven.package = pkgs.dns-heaven;
              }
            ];
            };

            nixosConfig = username: nixpkgs.lib.nixosSystem {
              inherit system;

              modules = [
                ./configuration.nix
                home.nixosModules.home-manager
                nix-library.homeModules.all
                {
                  home-manager.users.${username} = import ./home.nix;
                }
              ];
            };

            homeManagerConfig = username: home.lib.homeManagerConfiguration {
              inherit username system pkgs;
              homeDirectory = "/home";
              configuration = import ./home.nix;
            };
          in
          {
            nixosConfigurations = {
              nixos = nixosConfig "peteresselius";
            };

            darwinConfigurations = {
              Pepps-MacBook-Pro = darwinConfig "peteresselius";
              Vagrants-MacBook-Pro = darwinConfig "vagrant";
            };

            homeManagerConfigurations = {
              peteresselius = homeManagerConfig "peteresselius";
              vagrant = homeManagerConfig "vagrant";
            };

            apps = nix-library.lib.scripts self;
          }
        );
    in
    flake // {
      darwinConfigurations = flake.darwinConfigurations.x86_64-darwin;
      homeManagerConfigurations = flake.homeManagerConfigurations.x86_64-linux;
      nixosConfigurations = flake.nixosConfigurations.x86_64-linux;
    };
}

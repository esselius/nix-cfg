{ self, nixpkgs, darwin, home, flake-utils, library, ... }@inputs:
let
  systems = [ "x86_64-linux" "x86_64-darwin" ];

  flake = flake-utils.lib.eachSystem systems
    (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = with library.overlays; [
            packages
            switchScripts
          ];
        };

        darwinConfig = username: darwin.lib.darwinSystem {
          modules = [
            home.darwinModules.home-manager

            library.darwinModules.all
            library.homeModules.all

            ./darwin-configuration.nix

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
            library.homeModules.all
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

        apps = pkgs.switchScripts self;
      }
    );
in
flake // {
  darwinConfigurations = flake.darwinConfigurations.x86_64-darwin;
  homeManagerConfigurations = flake.homeManagerConfigurations.x86_64-linux;
  nixosConfigurations = flake.nixosConfigurations.x86_64-linux;
}

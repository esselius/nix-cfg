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
          ];
        };

        switchScripts = pkgs.callPackage ./lib/switchScripts.nix { inherit darwin; };

        darwinConfig = username: darwin.lib.darwinSystem {
          modules = [
            home.darwinModules.home-manager

            library.darwinModules.all
            library.homeModules.all

            ./darwin/darwin-configuration.nix

            {
              home-manager.users.${username} = import ./home/home.nix;
            }

            {
              services.yubikey-agent.enable = true;
              services.yubikey-agent.package = pkgs.yubikey-agent;

              services.dns-heaven.enable = true;
              services.dns-heaven.package = pkgs.dns-heaven;
            }
          ];
        };

        homeManagerConfig = username: home.lib.homeManagerConfiguration {
          inherit username system pkgs;
          homeDirectory = "/home";
          configuration = import ./home/home.nix;
        };
      in
      {
        lib = {
          inherit switchScripts;
        };

        darwinConfigurations = {
          Pepps-MacBook-Pro = darwinConfig "peteresselius";
          Vagrants-MacBook-Pro = darwinConfig "vagrant";
        };

        homeManagerConfigurations = {
          peteresselius = homeManagerConfig "peteresselius";
          vagrant = homeManagerConfig "vagrant";
        };

        apps = switchScripts self;

        devShell = pkgs.mkShell {
          buildInputs = with pkgs; with (switchScripts self); [
            gitMinimal

            switchNixOS
            switchDarwin
            switchHome
          ];
        };
      }
    );
in
flake // {
  darwinConfigurations = flake.darwinConfigurations.x86_64-darwin;
  homeManagerConfigurations = flake.homeManagerConfigurations.x86_64-linux;
}

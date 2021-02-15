{
  description = "Nix Config of Pepp";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home.url = "github:nix-community/home-manager";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, darwin, home, flake-utils }:
    let
      systems = [ "x86_64-linux" "x86_64-darwin" ];
      flake = flake-utils.lib.eachSystem systems
        (system:
          let
            pkgs = import nixpkgs {
              inherit system;
            };

            scripts = import ./lib/scripts.nix { inherit pkgs darwin; flake = self; };

            darwinConfig = username: darwin.lib.darwinSystem {
              modules = [
                ./darwin-configuration.nix
                ./modules/yubikey-agent.nix
                home.darwinModules.home-manager
                {
                  home-manager.backupFileExtension = "backup";
                  home-manager.useGlobalPkgs = true;
                  home-manager.useUserPackages = true;

                  home-manager.users.${username} = import ./home.nix;

                  services.yubikey-agent.enable = true;
                }
              ];
            };

            nixosConfig = username: nixpkgs.lib.nixosSystem {
              inherit system;

              modules = [
                ./configuration.nix
                home.nixosModules.home-manager
                {
                  home-manager.backupFileExtension = "backup";
                  home-manager.useGlobalPkgs = true;
                  home-manager.useUserPackages = true;

                  home-manager.users.${username} = import ./home.nix;
                }
              ];
            };


            homeDirPrefix = pkgs: "/home";

            homeManagerConfig = username: home.lib.homeManagerConfiguration {
              inherit username system pkgs;
              homeDirectory = homeDirPrefix pkgs;
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

            apps = scripts;

            devShell = pkgs.mkShell {
              buildInputs = with scripts; [
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
      nixosConfigurations = flake.nixosConfigurations.x86_64-linux;
    };
}

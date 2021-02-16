{
  description = "Nix Config of Pepp";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home.url = "github:nix-community/home-manager";
    flake-utils.url = "github:numtide/flake-utils";

    dns-heaven.url = "github:jduepmeier/dns-heaven?ref=v1.1.0";
    dns-heaven.flake = false;
  };

  outputs = { self, nixpkgs, darwin, home, flake-utils, ... }@inputs:
    let
      systems = [ "x86_64-linux" "x86_64-darwin" ];
      flake = flake-utils.lib.eachSystem systems
        (system:
          let
            overlay = final: prev:
              let
                pkg = name: input: prev.callPackage (./pkgs + "/${name}.nix") { src = input; };
                deNix = filename: prev.lib.removeSuffix ".nix" filename;
              in
              prev.lib.mapAttrs'
                (filename: _: prev.lib.nameValuePair
                  (deNix filename)
                  (pkg (deNix filename) inputs.${deNix filename}))
                (builtins.readDir ./pkgs);

            pkgs = import nixpkgs {
              inherit system;
              overlays = [ overlay ];
            };

            scripts = import ./lib/scripts.nix { inherit pkgs darwin; flake = self; };

            darwinConfig = username: darwin.lib.darwinSystem {
              modules = [
                ./darwin-configuration.nix
                ./modules/yubikey-agent.nix
                ./modules/dns-heaven.nix
                home.darwinModules.home-manager
                {
                  home-manager.backupFileExtension = "backup";
                  home-manager.useGlobalPkgs = true;
                  home-manager.useUserPackages = true;

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

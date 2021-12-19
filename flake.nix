{
  description = "Nix Config of Pepp";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-21.05";
    flake-utils.url = "github:numtide/flake-utils";

    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home.url = "github:moinessim/home-manager/nix-2.4-nix-darwin-modules";
    home.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = github:ryantm/agenix;
    pre-commit-hooks.url = "github:Myhlamaeus/pre-commit-hooks.nix/bd7cea29e61458bc3d29dccad6fb312dc1bc672d";

    flakebox.url = "github:esselius/nix-flakebox";
    flakebox.inputs.nixpkgs.follows = "nixpkgs";

    dns-heaven.url = "github:jduepmeier/dns-heaven?rev=3a38e6cb0430753b579490b8bd4652e3fda5fc5d";
    dns-heaven.flake = false;
    viscosity-sh.url = "github:andreax79/viscosity.sh?rev=407385f43f0c5d149af4eafa9f6ae09e7895288d";
    viscosity-sh.flake = false;
    log4brains.url = "github:thomvaill/log4brains";
    log4brains.flake = false;
  };

  outputs = inputs:
    let
      inherit (import ./lib inputs) switchers overlays importModulesDir;
    in
    {
      inherit overlays;
      inherit (switchers) apps devShell;

      darwinModules = importModulesDir ./darwin/modules;
      darwinConfigurations = import ./darwin/configurations inputs;

      homeModules = importModulesDir ./home/modules;
      homeManagerConfigurations = import ./home/configurations inputs;

      nixosModules = importModulesDir ./nixos/modules;
      nixosConfigurations = import ./nixos/configurations inputs;
    };
}

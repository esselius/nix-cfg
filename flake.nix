{
  description = "Nix Config of Pepp";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home.url = "github:nix-community/home-manager?rev=da923602089501142855bbb3c276fbc36513eefb";
    home.inputs.nixpkgs.follows = "nixpkgs";

    dns-heaven.url = "github:jduepmeier/dns-heaven?rev=3a38e6cb0430753b579490b8bd4652e3fda5fc5d";
    dns-heaven.flake = false;
    viscosity-sh.url = "github:andreax79/viscosity.sh?rev=407385f43f0c5d149af4eafa9f6ae09e7895288d";
    viscosity-sh.flake = false;
  };

  outputs = inputs:
    let
      library  = import ./library  inputs;
      vagrant  = import ./vagrant  (inputs // { inherit library; });
      personal = import ./personal (inputs // { inherit library vagrant; });
    in
    library // vagrant // personal;
}
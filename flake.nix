{
  description = "Nix Config of Pepp";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home.url = "github:nix-community/home-manager?rev=da923602089501142855bbb3c276fbc36513eefb";
    home.inputs.nixpkgs.follows = "nixpkgs";

    dns-heaven.url = "github:jduepmeier/dns-heaven?ref=v1.1.0";
    dns-heaven.flake = false;
  };

  outputs = inputs:
    let
      library  = import ./library  inputs;
      vagrant  = import ./vagrant  (inputs // { inherit library; });
      personal = import ./personal (inputs // { inherit library vagrant; });
    in
    library // vagrant // personal;
}
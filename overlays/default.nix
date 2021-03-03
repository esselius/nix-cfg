{ inputs, ... }:

{
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
    overlays = [
      (final: prev: {
        dns-heaven = prev.callPackage ./dns-heaven { src = inputs.dns-heaven; };
        viscosity-sh = prev.callPackage ./viscosity-sh { src = inputs.viscosity-sh; };
      })
    ];
  };
}

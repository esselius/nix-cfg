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

      (final: prev: {
        open-vm-tools = prev.open-vm-tools.overrideDerivation (oldAttrs: {
          postPatch = oldAttrs.postPatch + ''
            sed -i 's,/usr/bin/vmhgfs-fuse,/run/current-system/sw/bin/vmhgfs-fuse,' services/plugins/vix/foundryToolsDaemon.c
          '';
        });
      })
    ];
  };
}

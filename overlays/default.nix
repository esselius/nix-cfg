inputs:
{
  dns-heaven = final: prev: {
    dns-heaven = prev.callPackage ./dns-heaven { src = inputs.dns-heaven; };
  };

  viscosity-sh = final: prev: {
    viscosity-sh = prev.callPackage ./viscosity-sh { src = inputs.viscosity-sh; };
  };

  log4brains = final: prev: {
    log4brains = prev.callPackage ./log4brains { src = inputs.log4brains; };
  };

  open-vm-tools = final: prev: {
    open-vm-tools = prev.open-vm-tools.overrideDerivation (
      oldAttrs: {
        postPatch = oldAttrs.postPatch + ''
          sed -i 's,/usr/bin/vmhgfs-fuse,/run/current-system/sw/bin/vmhgfs-fuse,' services/plugins/vix/foundryToolsDaemon.c
        '';
      }
    );
  };
}

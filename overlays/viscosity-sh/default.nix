{ src, writeScriptBin, stdenv }:
writeScriptBin "vpn" ''
  #!${stdenv.shell}

  ${src}/viscosity.sh connect all
''

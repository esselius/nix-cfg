{ lib, pkgs, ... }:

{
  # home.file.".gnupg/scdaemon.conf".text = ''
  #   disable-ccid
  #   pcsc-driver ${lib.getLib pkgs.pcsclite}/lib/libpcsclite.${if pkgs.stdenv.isDarwin then "dylib" else "so"}
  #   pcsc-shared
  # '';

  # home.file.".gnupg/gpg-agent.conf".text = ''
  #   enable-ssh-support
  #   scdaemon-program ${pkgs.gnupg-pkcs11-scd}/bin/gnupg-pkcs11-scd
  # '';

  # home.file.".gnupg/gnupg-pkcs11-scd.conf".text = ''
  #   providers opensc

  #   provider-opensc-library ${pkgs.opensc}/lib/pkcs11/onepin-opensc-pkcs11.so

  #   openpgp-auth 5105BC243AAB50ED3CAA1323C72063BC790C1B8C
  # '';
}

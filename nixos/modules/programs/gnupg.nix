{ pkgs, ... }:

{
  programs.gnupg = {
    # package = pkgs.gnupg23.override { pcsclite = pkgs.pcsclite; };
    agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
}

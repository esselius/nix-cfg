{ config, pkgs, nix, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.useDHCP = false;
  networking.interfaces.ens33.useDHCP = true;

  security.sudo.wheelNeedsPassword = false;

  users.users.peteresselius = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    shell = pkgs.fish;
  };

  system.stateVersion = "20.09";

  services.sshd.enable = true;
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes ca-references
    '';
  };

  programs = {
    sysdig.enable = true;
  };
  programs.fish.enable = true;

  virtualisation.docker.enable = true;
  virtualisation.docker.listenOptions = [ "/var/run/docker.sock" "2375" ];
  virtualisation.docker.extraOptions = "--bip 172.17.42.1/24";

  networking.extraHosts = ''
    127.0.0.1 dev.localhost
  '';
}

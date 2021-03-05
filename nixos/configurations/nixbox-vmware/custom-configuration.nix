{ config, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    autorun = true;

    displayManager.sddm.enable = true;
    displayManager.autoLogin.enable = true;
    displayManager.autoLogin.user = "vagrant";

    desktopManager.plasma5.enable = true;
  };
}

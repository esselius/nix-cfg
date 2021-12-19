{ pkgs, ... }:

{
  # nix = {
  #   package = pkgs.nixUnstable;
  #   extraOptions = ''
  #     experimental-features = nix-command flakes ca-references
  #   '';
  # };

  services.xserver.enable = true;
  services.xserver.displayManager.defaultSession = "none+i3";
  services.xserver.windowManager.i3.enable = true;

  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "vagrant";
}

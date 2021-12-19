{ pkgs, ... }:

{
  services.kubernetes = {
    roles = [ "master" "node" ];
    masterAddress = "localhost";
  };

  environment.systemPackages = with pkgs; [
    kubectl
  ];
}

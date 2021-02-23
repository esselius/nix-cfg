{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.dns-heaven;
in
{
  options = {
    services.dns-heaven = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to start dns-heaven when you log in.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.dns-heaven;
        defaultText = "pkgs.dns-heaven";
        description = ''
          The package used for the dns-heaven service.
        '';
      };

      address = mkOption {
        type = types.str;
        default = "127.0.0.1:53";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    launchd.daemons.dns-heaven.serviceConfig = {
      ProgramArguments = [
        "${cfg.package}/bin/dns-heaven"
        "-address"
        cfg.address
      ];
      RunAtLoad = true;
      KeepAlive = true;
    };
  };
}

# Global configuration for yubikey-agent.

{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.yubikey-agent;
in
{
  options = {
    services.yubikey-agent = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to start yubikey-agent when you log in. Also sets
          SSH_AUTH_SOCK to point at yubikey-agent.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.yubikey-agent;
        defaultText = "pkgs.yubikey-agent";
        description = ''
          The package used for the yubikey-agent daemon.
        '';
      };
    };
  };

  config = {
    environment.systemPackages = [ cfg.package ];

    launchd.user.agents.yubikey-agent.serviceConfig = {
      ProgramArguments = [
        "${pkgs.yubikey-agent}/bin/yubikey-agent"
        "-l"
        "/tmp/yubikey-agent.sock"
      ];
      RunAtLoad = cfg.enable;
      KeepAlive = true;
    };


    environment.extraInit = optionalString cfg.enable ''
      export SSH_AUTH_SOCK="/tmp/yubikey-agent.sock"
    '';
  };
}

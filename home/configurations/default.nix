{ home, ... }@inputs:
let
  hmConfig = { username, homeDirectory, system, configuration }:
    home.lib.homeManagerConfiguration {
      inherit username homeDirectory system configuration;

      extraSpecialArgs = { inherit inputs; };
    };
in
{
  peteresselius = hmConfig {
    username = "peteresselius";
    homeDirectory = "/Users/peteresselius";
    system = "x86_64-darwin";

    configuration = {
      imports = [
        ./peteresselius
      ];
    };
  };

  vagrant = hmConfig {
    username = "vagrant";
    homeDirectory = "/home/vagrant";
    system = "x86_64-linux";

    configuration = {
      imports = [
        ./peteresselius
      ];
      xsession.windowManager.i3 = {
        enable = true;
        config.terminal = "kitty";
      };
    };
  };
}

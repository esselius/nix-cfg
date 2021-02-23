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
}

{ darwin, home, ... }@inputs:
{
  Pepps-MacBook-Pro = darwin.lib.darwinSystem
    {
      inherit inputs;
      modules = [
        {
          imports = import ../modules;

          programs = {
            fish.enable = true;
            zsh.enable = true;
          };

          services = {
            yubikey-agent.enable = true;
            dns-heaven.enable = true;
            skhd.enable = true;
            spacebar.enable = true;
            yabai.enable = true;
          };

          users.users.peteresselius = {
            home = "/Users/peteresselius";
          };
        }

        {
          imports = [ home.darwinModules.home-manager ];

          home-manager.useGlobalPkgs = false;
          home-manager.useUserPackages = false;
          home-manager.backupFileExtension = "backup";

          home-manager.extraSpecialArgs = { inherit inputs; };

          home-manager.users.peteresselius = import ../../home/configurations/peteresselius;
        }
      ];
    };
}

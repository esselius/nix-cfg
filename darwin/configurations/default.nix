{ darwin, home, ... }@inputs:
{
  Pepps-MacBook-Pro = darwin.lib.darwinSystem
    {
      inherit inputs;
      system = "x86_64-darwin";
      modules = [
        {
          imports = import ../modules;

          programs = {
            fish.enable = true;
            fish.shellInit = ''
              export PATH=/usr/local/smlnj/bin:"$PATH"
            '';
            zsh.enable = true;
            gnupg = {
              agent = {
                enable = true;
                enableSSHSupport = true;
              };
            };
          };

          services = {
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

        {
          homebrew = {
            enable = true;

            brews = [
              "minikube"
              "docker-machine-driver-vmware"
            ];

            casks = [
              "1password"
              "alfred"
              # "monitorcontrol"
              "vagrant-vmware-utility"
              "vagrant"
              "virtualbox-extension-pack"
              "virtualbox"
              "vmware-fusion"
              "xquartz"
              "smlnj"
              "google-cloud-sdk"
            ];
          };
        }
      ];
    };

  Vagrants-Mac = darwin.lib.darwinSystem
    {
      inherit inputs;
      system = "x86_64-darwin";
      modules = [
        {
          imports = import ../modules;

          programs = {
            fish.enable = true;
            zsh.enable = true;
          };

          users.users.vagrant = {
            home = "/Users/vagrant";
          };
        }

        {
          imports = [ home.darwinModule ];

          home-manager.useGlobalPkgs = false;
          home-manager.useUserPackages = false;
          home-manager.backupFileExtension = "backup";

          home-manager.extraSpecialArgs = { inherit inputs; };

          home-manager.users.vagrant = import ../../home/configurations/peteresselius;
        }
      ];
    };
}

{ pkgs, ... }:

{
  programs = {
    home-manager.enable = true;

    fish = {
      enable = true;

      shellAliases = {
        gs = "git status -sb";
        "gcan!" = "git commit -v -a --no-edit --amend";
        gcam = "git commit -a -m";
        gp = "git push";
        gpsup = "git push --force-with-lease";
      };

      shellAbbrs = {
        gco = "git checkout";

        k    = "kubectl";
        kcuc = "kubectl config use-context";
        kccc = "kubectl config current-context";

        rg = "rg -S --hidden --glob '!.git/*'";
      };

      shellInit = ''
        source /etc/fish/config.fish

        # For all those secrets
        if test -e ~/.config/fish/env.fish
          source ~/.config/fish/env.fish
        end
      '';
    };

    starship = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        openstack.disabled = true;
        gcloud.disabled = true;
      };
    };
  };
}
{ pkgs, ... }:

{
  programs = {
    fish = {
      shellAliases = {
        gcb = "git checkout -b";
        gs = "git status -sb";
        "gcan!" = "git commit -v -a --no-edit --amend";
        gcam = "git commit -a -m";
        gl = "git pull";
        gp = "git push";
        gpsup = "git push --set-upstream origin (git rev-parse --abbrev-ref HEAD)";
        gpf = "git push --force-with-lease";
      };

      shellAbbrs = {
        gco = "git checkout";

        k = "kubectl";
        kcuc = "kubectl config use-context";
        kccc = "kubectl config current-context";

        rg = "rg -S --hidden --glob '!.git/*'";
      };

      functions = {
        gwi-test = {
          argumentNames = [
            "namespace"
            "serviceaccount"
          ];
          body = ''
            kubectl run --rm -it --image google/cloud-sdk:slim --namespace $namespace --serviceaccount $serviceaccount gwi-test -- gcloud auth list
          '';
        };
      };

      shellInit = ''
        set -x DIRENV_LOG_FORMAT ""
        ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source

        source /etc/fish/config.fish

        # For all those secrets
        if test -e ~/.config/fish/env.fish
          source ~/.config/fish/env.fish
        end
      '';
    };

    starship = {
      enableFishIntegration = true;
      settings = {
        openstack.disabled = true;
        gcloud.disabled = true;
        vagrant.disabled = true;
        git_status.disabled = true;
        kubernetes = {
          disabled = false;
          context_aliases = {
            gke_pagero-cluster-api_europe-north1_cluster-api = "gke-cluster-api";
            gke_pagero-build_europe-north1_build-regional = "gke-build";
            gke_pagero-prod_europe-north1_production = "gke-prod";
            gke_pagero-staging_europe-north1_staging = "gke-staging";
            gke_pagero-test_europe-north1_test = "gke-test";
            "prod-1-cluster-1-admin@prod-1-cluster-1" = "nrd-prod-1";
            "staging-1-cluster-1-admin@staging-1-cluster-1" = "nrd-staging-1";
          };
        };
      };
    };
  };
}

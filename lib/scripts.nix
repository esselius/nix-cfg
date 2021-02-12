{ pkgs, darwin, flake }:
with pkgs; let
  flakesDarwinSystem = darwin.lib.darwinSystem {
    modules = [ ({ pkgs, ... }: { nix.package = pkgs.nixFlakes; }) ];
  };
in
{
  switchDarwin = writeShellScriptBin "switch-darwin" ''
    set -euo pipefail

    unlinkResult() {
        if [[ -L result ]]; then
            unlink result
        fi
    }

    trap unlinkResult EXIT

    ${flakesDarwinSystem.system}/sw/bin/darwin-rebuild switch --flake ${flake} "$@"
  '';
}

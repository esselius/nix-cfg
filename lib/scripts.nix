{ pkgs, darwin, flake }:
with pkgs; let
  flakesDarwinSystem = darwin.lib.darwinSystem {
    modules = [ ({ pkgs, ... }: { nix.package = pkgs.nixFlakes; }) ];
  };
in
{
  switchDarwin = writeShellScriptBin "switch-darwin" ''
    set -euo pipefail

    if ! [[ -d /run ]]; then
        if ! grep -q run /etc/synthetic.conf; then
            echo -e 'run\tprivate/var/run' | sudo tee -a /etc/synthetic.conf
        fi

        util=/System/Library/Filesystems/apfs.fs/Contents/Resources/apfs.util

        # Big Sur switched to `-t`
        if ($util -h || true) | grep -q '\-B'; then
            $util -B
        else
            $util -t
        fi
    fi

    unlinkResult() {
        if [[ -L result ]]; then
            unlink result
        fi
    }

    trap unlinkResult EXIT

    ${flakesDarwinSystem.system}/sw/bin/darwin-rebuild switch --flake ${flake} "$@"
  '';
}

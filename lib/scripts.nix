{ pkgs, darwin, flake }:
with pkgs; let
  flakesDarwinSystem = darwin.lib.darwinSystem {
    modules = [ ({ pkgs, ... }: { nix.package = pkgs.nixFlakes; }) ];
  };
in
{
  switchNixOS = writeShellScriptBin "switch-darwin" ''
    nixos-rebuild switch --flake ${flake} "$@"
  '';
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

  switchHome = writeShellScriptBin "switch-home" ''
    set -euo pipefail
    set -x

    if ! grep -q flakes /etc/nix/nix.conf; then
      echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf
      sudo killall nix-daemon
      sleep 1
    fi

    export PATH=${lib.makeBinPath [ gitMinimal jq nixUnstable ]}
    usr="''${1:-$USER}"

    1>&2 echo "Building configuration..."

    out="$(nix build --json ".#homeManagerConfigurations.$usr.activationPackage" | jq -r .[].outputs.out)"

    1>&2 echo "Activating configuration..."

    "$out"/activate
  '';
}

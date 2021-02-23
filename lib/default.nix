{ self, nixpkgs, darwin, flake-utils, ... }:
with builtins;
let
  inherit (nixpkgs) lib;

  rawDarwinSystem = darwin.lib.darwinSystem {
    modules = [ ({ pkgs, ... }: { nix.package = pkgs.nixFlakes; }) ];
  };
  darwinRebuild = "${rawDarwinSystem.system}/sw/bin/darwin-rebuild";

  nixosRebuild = "${pkgs.nixos-rebuild.override { nix = pkgs.nixUnstable; }}/bin/nixos-rebuild";
in
{
  importModulesDir = dir:
    lib.fold lib.recursiveUpdate { } (map
      (path:
        lib.setAttrByPath
          (lib.pipe path [
            toString
            (lib.removePrefix "${toString dir}/")
            (lib.removeSuffix ".nix")
            (lib.strings.splitString "/")
          ])
          (import path))
      (lib.filesystem.listFilesRecursive dir));

  switchScripts = system:
  let
    pkgs = import nixpkgs {
      inherit system;
    };

    inherit (pkgs) writeShellScriptBin;
  in
  {
    switchNixOS = writeShellScriptBin "switch-nixos" ''
      ${nixosRebuild} switch --flake ${self} "$@"
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

      ${darwinRebuild} switch --flake ${self} "$@"
    '';

    switchHome = writeShellScriptBin "switch-home" ''
      set -euo pipefail

      out="$(nix build --json ".#homeManagerConfigurations.$USER.activationPackage" | jq -r .[].outputs.out)"

      "$out"/activate
    '';
  };
}

{ self, nixpkgs, darwin, flake-utils, flakebox, ... }@inputs:
let
  inherit (nixpkgs.lib) filter fold recursiveUpdate setAttrByPath pipe removePrefix removeSuffix strings hasSuffix filesystem attrValues;
  inherit (flakebox.lib) vagrantBuildFlake;

  overlays = (import ../overlays inputs);
in
{
  inherit overlays;

  importModulesDir = dir:
    fold recursiveUpdate { } (map
      (path:
        setAttrByPath
          (pipe path [
            toString
            (removePrefix "${toString dir}/")
            (removeSuffix ".nix")
            (strings.splitString "/")
          ])
          (import path)
      )
      (filter (path: ! hasSuffix "default.nix" (toString path)) (filesystem.listFilesRecursive dir)));

  switchers = flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
        overlays = attrValues overlays;
      };

      inherit (pkgs) writeShellScriptBin;
      inherit (pkgs.lib) makeBinPath;

      rawDarwinSystem = darwin.lib.darwinSystem {
        modules = [ ({ pkgs, ... }: { nix.package = pkgs.nixFlakes; }) ];
      };
      darwinRebuild = "${rawDarwinSystem.system}/sw/bin/darwin-rebuild";

      nixosRebuild = "${pkgs.nixos-rebuild.override { nix = pkgs.nixUnstable; }}/bin/nixos-rebuild";

      switchScripts = {
        switchNixOS = writeShellScriptBin "switch-nixos" ''
          ${nixosRebuild} switch --flake ${self} "$@"
        '';

        switchDarwin = writeShellScriptBin "switch-darwin" ''
          set -euo pipefail

          export TERM="''${TERM/xterm-kitty/xterm-256color}"

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

          if [[ -L result ]]; then
              unlink result
          fi

          ${darwinRebuild} switch --flake ${self} "$@"
          unlink result
        '';

        switchHome = writeShellScriptBin "switch-home" ''
          set -euo pipefail

          export TERM="''${TERM/xterm-kitty/xterm-256color}"

          export PATH=${makeBinPath [ pkgs.nixUnstable pkgs.git pkgs.jq ]}

          out="$(nix --experimental-features 'nix-command flakes' build --json ".#homeManagerConfigurations.$USER.activationPackage" | jq -r .[].outputs.out)"

          "$out"/activate
        '';

        rebuildNixOSVM = writeShellScriptBin "rebuild-nixos-vm" ''
          set -e
          rm -f packer_vmware-iso_vmware.box

          ${pkgs.callPackage vagrantBuildFlake { flake = self; }}/bin/packer-build-vmware-vagrant-box

          vagrant box add --force esselius/nix-cfg-nixos packer_vmware-iso_vmware.box
          vagrant destroy -f nixos
          vagrant up nixos
        '';
      };
    in
    {
      apps = switchScripts;

      devShell = pkgs.mkShell {
        buildInputs = with pkgs; with switchScripts; [
          gitMinimal
          jq

          switchDarwin
          switchHome
          switchNixOS

          rebuildNixOSVM
        ];
      };
    }
  );
}

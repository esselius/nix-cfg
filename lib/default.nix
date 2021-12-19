{ self, nixpkgs, darwin, flake-utils, flakebox, pre-commit-hooks, ... }@inputs:
let
  inherit (nixpkgs.lib) filter fold recursiveUpdate setAttrByPath pipe removePrefix removeSuffix strings hasSuffix filesystem attrValues;
  inherit (flakebox.lib) packerBuild;
  inherit (flake-utils.lib) mkApp eachDefaultSystem;

  overlays = (import ../overlays inputs);
in
{
  inherit overlays;

  importModulesDir = dir:
    fold recursiveUpdate { } (
      map
        (
          path:
          setAttrByPath
            (
              pipe path [
                toString
                (removePrefix "${toString dir}/")
                (removeSuffix ".nix")
                (strings.splitString "/")
              ]
            )
            (import path)
        )
        (filter (path: ! hasSuffix "default.nix" (toString path)) (filesystem.listFilesRecursive dir))
    );

  switchers = eachDefaultSystem (
    system:
    let
      pre-commit-check = pre-commit-hooks.packages.${system}.run {
        src = ./.;

        hooks = {
          nixpkgs-fmt.enable = true;
        };
      };

      pkgs = import nixpkgs {
        inherit system;
        overlays = attrValues overlays;
      };

      inherit (pkgs) writeShellScriptBin;
      inherit (pkgs.lib) makeBinPath;

      rawDarwinSystem = darwin.lib.darwinSystem {
        system = "x86_64-darwin";
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

        resetVagrant = writeShellScriptBin "rebuild-vagrant" ''
          vagrant destroy -f nixos

          ${packerBuild { flake = flakebox; nixosConfig = "vmwareBase"; disk_size = "100000"; }}/bin/packer-build
          vagrant box add --force esselius/nix-cfg-nixos packer_vmware-iso_vmware.box
          rm packer_vmware-iso_vmware.box

          vagrant up nixos
        '';

      };
    in
    {
      apps = with switchScripts; {
        switch-darwin = mkApp { drv = switchDarwin; };
        switch-home = mkApp { drv = switchHome; };
        switch-nixos = mkApp { drv = switchNixOS; };
        reset-vagrant = mkApp { drv = resetVagrant; };
      };

      devShell = pkgs.mkShell {
        inherit (pre-commit-check) shellHook;

        buildInputs = with pkgs; with switchScripts; [
          gitMinimal
          jq

          # switchDarwin
          switchHome
          switchNixOS

          # rebuildNixOSVM
        ];
      };
    }
  );
}

{ pkgs, inputs, ... }:

let
  inherit (pkgs.lib) makeBinPath;
  inherit (pkgs) _1password age;
in
{
  home.packages = [
    (pkgs.writers.writeBashBin "secrets-sync" ''
      export PATH="$PATH:${makeBinPath [ _1password age ]}"

      op signin | eval

      cat <<EOF | sops --input-type yaml --output-type yaml -e /dev/stdin > secrets.yaml
      github_token: $(op get item GitHub --fields token)
      EOF
    '')
  ];
}

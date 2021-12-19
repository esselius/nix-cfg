{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writers.writeBashBin "github-repos" ''
      ${pkgs.gh}/bin/gh repo list "$1" -L 1000 --json sshUrl -q '.[].sshUrl'
    '')

    (pkgs.writers.writeBashBin "github-starred" ''
      ${pkgs.gh}/bin/gh api /user/starred --paginate -q '.[].ssh_url'
    '')

    (pkgs.writers.writeBashBin "github-sync" ''
      github-starred | ${pkgs.ghq}/bin/ghq get -u -P
      github-repos "$GITHUB_USER" | ${pkgs.ghq}/bin/ghq get -u -P

      for org in $GITHUB_ORGS; do
        github repos "$org" | ${pkgs.ghq}/bin/ghq get -u -P
      done
    '')
  ];
}

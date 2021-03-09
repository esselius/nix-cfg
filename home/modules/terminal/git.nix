{
  programs.git = {
    enable = true;
    lfs.enable = true;
    delta = {
      enable = true;
      options = {
        features = "side-by-side line-numbers decorations";
        syntax-theme = "Solarized (light)";
      };
    };

    userName = "Peter Esselius";

    aliases = {
      l = "log --graph --decorate --pretty=format:\"%C(yellow)%h%C(reset)%C(auto)%d%C(reset) %s %C(yellow)(%C(cyan)%ar%C(yellow), %C(blue)%an%C(yellow))%C(reset)\"";
      ll = "log --graph --decorate --stat --pretty=format:\"%C(yellow)%h%C(reset)%C(auto)%d%C(reset) %s%n %C(cyan)%ar%C(reset), %C(blue)%an%C(reset)%n\"";
      wc = "whatchanged -p --abbrev-commit --pretty=medium";
      dc = "diff --cached";
      dw = "diff --color-words";
      ds = "diff --stat";
      cc = "!git log --format=format: --name-only | egrep -v '^$' | sort | uniq -c | sort -rg | head -10";
      unstage = "reset HEAD";
      uncommit = "reset --soft HEAD^";
      recommit = "commit --amend";
    };

    ignores = [
      ".*.swp"
      ".DS_Store"
      ".metals/"
      ".bloop/"
      ".vscode/"
    ];

    extraConfig = {
      ghq = {
        root = "~/src";
      };
      url."git@github.com:".insteadOf = "https://github.com";
    };
  };
}

{ pkgs, ... }:

{
  home = {
    file.".asdf".source = pkgs.fetchFromGitHub {
      owner = "asdf-vm";
      repo = "asdf";
      rev = "v0.8.0";
      sha256 = "sha256-E4mN94QITyqxypvWjzLi21XKP+D1M6ya4vTJr9oQ9h4=";
    };

    sessionVariables = {
      ASDF_DATA_DIR = "$HOME/.asdf-data";
    };
  };

  programs.fish.shellInit = ''
    source $HOME/.asdf/asdf.fish
  '';
}

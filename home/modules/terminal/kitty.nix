{ pkgs, ... }:

{
  programs = {
    kitty = {
      font = {
        name = "Fira Code";
        package = pkgs.fira-code;
      };
      settings = {
        font_size = "14.0";
        cursor_shape = "underline";
        clipboard_control = "write-clipboard write-primary no-append";
      };
    };
  };
  home.sessionVariables = {
    TERMINAL = "kitty";
  };
}

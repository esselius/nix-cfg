{
  programs.tmux = {
    enable = true;

    terminal = "screen-256color";

    keyMode = "vi";
    shortcut = "a";
    customPaneNavigationAndResize = true;

    extraConfig = ''
      set-option -g mouse on
      set -g history-limit 1000000000

      # Hotkey for synchronizing pane keystrokes
      bind S setw synchronize-panes

      # More easily remembered split
      bind | split-window -h
      bind - split-window -v

      # Styling
      set -g status-bg black
      set -g status-fg green
      set -g status-left-length 50
      set -g status-left ' #[fg=cyan,bright]#20H#[fg=green]:#[fg=white]#S#[fg=green] | #[default]'
      set -g status-right '| #[fg=yellow]%y-%m-%d %H:%M '
      set -g status-justify centre
      set -g status-position top
    '';
  };
}

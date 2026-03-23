{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    prefix = "C-Space";
    terminal = "screen-256color";
    keyMode = "vi";
    baseIndex = 1;
    escapeTime = 10;

    plugins = with pkgs.tmuxPlugins; [
      sensible
      vim-tmux-navigator
      better-mouse-mode
      fzf-tmux-url
      yank
    ];

    extraConfig = ''
      set-option -sa terminal-overrides ",xterm*:Tc"
      set-option -g focus-events on

      # quick commands
      bind -n M-: command-prompt

      # Open panes at current dir
      bind - split-window -v -c "#{pane_current_path}"
      bind _ split-window -h -c "#{pane_current_path}"
      unbind '"'
      unbind %

      # Open windows at current dir
      bind c new-window -c "#{pane_current_path}"

      # selection keybinds
      bind-key -n M-V copy-mode
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

      # pane base index
      set-window-option -g pane-base-index 1
      set-option -g renumber-windows on

      # reset source
      bind-key -n M-Q source-file "~/.config/tmux/tmux.conf"

      # Alt + left hand for panes
      bind -n M-a select-pane -L
      bind -n M-r select-pane -D
      bind -n M-s select-pane -U
      bind -n M-t select-pane -R
      bind -n M-d split-window -h -c "#{pane_current_path}"
      bind -n M-c split-window -v -c "#{pane_current_path}"
      bind -n M-p swap-pane -D
      bind -n M-f swap-pane -U

      ####---- COLEMAK-MDH BINDS ----####

      # Shift + Alt + right hand for windows
      bind-key -n M-N select-window -t 1
      bind-key -n M-E select-window -t 2
      bind-key -n M-I select-window -t 3
      bind-key -n M-O select-window -t 4
      bind-key -n M-M next-window
      bind-key -n M-J previous-window
      bind-key -n M-H new-window -c "#{pane_current_path}"
      bind-key -n M-K detach

      # Shift + Alt + left hand for sessions
      bind-key -n M-T switch -t 1
      bind-key -n M-S switch -t 2
      bind-key -n M-R switch -t 3
      bind-key -n M-A switch -t 4
      bind-key -n M-D switch -t 5
      bind-key -n M-C switch -t 6
      bind-key -n M-X switch -t 7
      bind-key -n M-Z switch -t 8
      bind-key -n M-G switch -n
      bind-key -n M-B switch -p
      bind-key -n M-F choose-tree

      # switch windows alt+number
      bind-key -n M-1 select-window -t 1
      bind-key -n M-2 select-window -t 2
      bind-key -n M-3 select-window -t 3
      bind-key -n M-4 select-window -t 4
      bind-key -n M-5 select-window -t 5
      bind-key -n M-6 select-window -t 6
      bind-key -n M-7 select-window -t 7
      bind-key -n M-8 select-window -t 8
      bind-key -n M-9 select-window -t 9

      ## styling ##

      # colors
      set -ag terminal-overrides ",$TERM:Tc"
      set -g status-style bg=black,fg=white

      # manual window names
      set-option -g automatic-rename off
      set-option -g allow-rename off

      # Inactive window style
      set -g window-status-style bg=black
      set -g window-status-format "#[fg=black,bold, bg=magenta] #I #[fg=black,nobold, bg=color8] #W #[default]"

      # Active window style
      set -g window-status-current-style bg=black
      set -g window-status-current-format "#[fg=black,bold, bg=cyan] #I #[fg=black,nobold, bg=color7] #W #[default]"

      # left
      set -g status-left-length 20
      set -g status-left "#[fg=black,bold, bg=yellow] #S #[bg=black] #[default]"

      # right
      set -g status-right-length 40
      set -g status-right " %F #[fg=black, bg=yellow] %T #[default]"
    '';
  };
}

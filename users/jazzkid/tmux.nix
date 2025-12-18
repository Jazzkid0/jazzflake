{ pkgs, ... }:
{
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
      yank
      catppuccin
    ];

    extraConfig = ''
      set-option -sa terminal-overrides ",xterm*:Tc"
      set-option -g focus-events on

      # Open panes at current dir
      bind - split-window -v -c "#{pane_current_path}"
      bind _ split-window -h -c "#{pane_current_path}"
      unbind '"'
      unbind %

      # Open windows at current dir
      bind c new-window -c "#{pane_current_path}"

      # selection keybinds
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

      # pane base index
      set -g pane-base-index 1
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
      bind-key -n M-G switch -n
      bind-key -n M-B switch -p
      bind-key -n M-F choose-tree
      bind-key -n M-D switch -t notes
      bind-key -n M-C switch -t config
      bind-key -n M-X switch -t nix
      bind-key -n M-Z switch -t test

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

      # colors
      set -ag terminal-overrides ",$TERM:Tc"
    '';
  };
}

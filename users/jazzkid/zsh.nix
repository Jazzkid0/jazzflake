{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    sessionVariables = {
      EDITOR = "nvim";
      SUDO_EDITOR = "nvim";
      CARAPACE_BRIDGES = "zsh,bash";
    };

    shellAliases = {
      # ls aliases
      la = "ls -A";
      ll = "ls -shalF";
      l = "ls -CF";

      # utility
      wakepc = "wakelan -m B0:6E:BF:DB:44:8C -b 192.168.1.100";
      resource = "source ~/.zshrc";
      nvim-latest = ''nix run "github:nix-community/neovim-nightly-overlay"'';

      # git auth
      gitauth_jazzkid = ''eval "$(ssh-agent -s)" && ssh-add ~/.ssh/id_ed25519_jonnnyk'';
      gitauth_jknightdev = ''eval "$(ssh-agent -s)" && ssh-add ~/.ssh/id_ed25519_jknightdev'';

      # vim-style exit
      ":q" = "exit";

      # tmux shortcuts
      t = "tmux attach";
      tls = "tmux list-sessions";
      tks = "tmux kill-session -t";
      ta = "tmux attach -t";
      ts = "tmux new-session -s";
      tsw = "tmux switch -t";
      tct = "tmux choose-tree";

      # grep with color
      grep = "grep --color=auto";
      fgrep = "fgrep --color=auto";
      egrep = "egrep --color=auto";
    };

    initContent = ''
      # Carapace completion
      zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
      source <(carapace _carapace)

      # Enable color support for ls
      if [ -x /usr/bin/dircolors ]; then
          test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
          alias ls='ls --color=auto'
      fi
    '';
  };
}

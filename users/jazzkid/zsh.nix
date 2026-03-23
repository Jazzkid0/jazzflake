{...}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    sessionVariables = {
      EDITOR = "nvim";
      SUDO_EDITOR = "nvim";
      CARAPACE_BRIDGES = "zsh,bash";
    };

    shellAliases = {
      t = "tmux attach";

      # ls aliases
      la = "ls -A";
      ll = "ls -shalF";
      l = "ls -CF";

      # utility
      wakepc = "wakelan -m B0:6E:BF:DB:44:8C -b 192.168.1.100";
      resource = "source ~/.zshrc";

      # misc
      nvim-latest = ''nix run "github:nix-community/neovim-nightly-overlay"'';
      rmd = "rich --markdown --force-terminal --center --text-center --padding 2,4 --theme monokai --width 80";
      rmf = "rmd $(fzf) | less"; # TODO: view markdown in nvim buffer
      jjts = ''jj ci -m"$(date +"%F|%T|%A")"'';

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

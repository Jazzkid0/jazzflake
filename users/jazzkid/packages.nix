{pkgs, ...}: {
  home.packages =
    (with pkgs; [
      vim
      wget
      curl
      git
      tree
      fastfetch
      gcc
      cmake
      gnumake
      ripgrep
      fzf
      unzip
      wakelan
      wireguard-tools
      gleam
      erlang_27
      rebar3
      nodejs
      bun
      inotify-tools
      flyctl
      fd
      markdown-oxide
      vimPlugins.rustaceanvim
      openssl
      lua-language-server
      bunbun
      carapace
      difftastic
      deploy-rs
      nixd
      rich-cli
      dig
      lego
      dust
      typescript-language-server
      python3
      uv
      ragenix
      nmap
      steam-run
      pay-respects
      attic-client
      jq
      age
      lynx
      btop
      xfce.thunar
      xfce.thunar-archive-plugin
      xfce.thunar-volman
    ])
    ++ (with pkgs; [
      ## UNFREE PACKAGES ----- see ./modules/common/unfree-whitelist.nix
    ])
    ++ (with pkgs; [
      ## stuff in my local cache, hopefully
      opencode
    ]);
}

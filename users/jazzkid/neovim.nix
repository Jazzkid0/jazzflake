{inputs, pkgs, ...}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = false;
    vimAlias = false;
    withRuby = false;
    withPython3 = false;
    plugins = with pkgs.vimPlugins; [
      rustaceanvim
    ];
  };

  # Link the neovim configuration from the flake input
  xdg.configFile."nvim" = {
    source = inputs.nvim-config;
    recursive = true;
  };
}

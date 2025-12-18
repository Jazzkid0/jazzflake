{ inputs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # Link the neovim configuration from the flake input
  xdg.configFile."nvim" = {
    source = inputs.nvim-config;
    recursive = true;
  };
}

{ ... }:
{
  imports = [
    ./zsh.nix
    ./git.nix
    ./starship.nix
    ./tmux.nix
    ./neovim.nix
    ./bat.nix
    ./jujutsu.nix
    ./zoxide.nix
    ./htop.nix
  ];

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        forwardAgent = true;
      };
      "nas.jazzkid.xyz" = {
        hostname = "nas.jazzkid.xyz";
        user = "jazzkid";
      };
    };
  };
}

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
    extraConfig = ''
      Host nas.jazzkid.xyz
        HostName nas.jazzkid.xyz
        User jazzkid
    '';
  };
}

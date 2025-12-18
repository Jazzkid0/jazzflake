{ ... }:
{

   imports = [
      ./zsh.nix
      ./git.nix
      ./starship.nix
      ./programs.nix
      ./tmux.nix
      ./neovim.nix
      ./packages.nix
   ];

   home.username = "jazzkid";
   home.homeDirectory = "/home/jazzkid";

   home.stateVersion = "24.05";

   programs.home-manager.enable = true;

}

{...}: {
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
      "github_jazzkid" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519_jazzkid";
        identitiesOnly = true;
      };
      "github_public" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519_public";
        identitiesOnly = true;
      };
      "jazzserver" = {
        hostname = "dev.jazzkid.xyz";
        user = "jazzkid";
      };
      "dev.jazzkid.xyz" = {
        hostname = "dev.jazzkid.xyz";
        user = "jazzkid";
      };
      "jazznas" = {
        hostname = "nas.jazzkid.xyz";
        user = "jazzkid";
      };
      "nas.jazzkid.xyz" = {
        hostname = "nas.jazzkid.xyz";
        user = "jazzkid";
      };
    };
  };
}

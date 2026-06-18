_: {
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
      "dev" = {
        hostname = "dev.jazzkid.xyz";
        user = "jazzkid";
      };
      "server" = {
        hostname = "dev.jazzkid.xyz";
        user = "jazzkid";
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
      "nas" = {
        hostname = "nas.jazzkid.xyz";
        user = "jazzkid";
      };
      "nas.jazzkid.xyz" = {
        hostname = "nas.jazzkid.xyz";
        user = "jazzkid";
      };
      "git_nas" = {
        hostname = "nas.jazzkid.xyz";
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
        identitiesOnly = true;
      };
      "pc" = {
        hostname = "pc.jazzkid.xyz";
        user = "jazzkid";
      };
      "pc.jazzkid.xyz" = {
        hostname = "pc.jazzkid.xyz";
        user = "jazzkid";
      };
      "jazznode" = {
        hostname = "exit-node.jazzkid.xyz";
        user = "exit-node";
      };
    };
  };
}

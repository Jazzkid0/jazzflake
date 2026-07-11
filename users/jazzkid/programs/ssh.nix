_: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*" = {
        ForwardAgent = true;
      };
      "github_jazzkid" = {
        HostName = "github.com";
        User = "git";
        IdentityFile = "~/.ssh/id_ed25519_jazzkid";
        IdentitiesOnly = true;
      };
      "github_public" = {
        HostName = "github.com";
        User = "git";
        IdentityFile = "~/.ssh/id_ed25519_public";
        IdentitiesOnly = true;
      };
      "dev" = {
        HostName = "dev.jazzkid.xyz";
        User = "jazzkid";
      };
      "server" = {
        HostName = "dev.jazzkid.xyz";
        User = "jazzkid";
      };
      "jazzserver" = {
        HostName = "dev.jazzkid.xyz";
        User = "jazzkid";
      };
      "dev.jazzkid.xyz" = {
        HostName = "dev.jazzkid.xyz";
        User = "jazzkid";
      };
      "jazznas" = {
        HostName = "nas.jazzkid.xyz";
        User = "jazzkid";
      };
      "nas" = {
        HostName = "nas.jazzkid.xyz";
        User = "jazzkid";
      };
      "nas.jazzkid.xyz" = {
        HostName = "nas.jazzkid.xyz";
        User = "jazzkid";
      };
      "git_nas" = {
        HostName = "nas.jazzkid.xyz";
        User = "git";
        IdentityFile = "~/.ssh/id_ed25519";
        IdentitiesOnly = true;
      };
      "pc" = {
        HostName = "pc.jazzkid.xyz";
        User = "jazzkid";
      };
      "pc.jazzkid.xyz" = {
        HostName = "pc.jazzkid.xyz";
        User = "jazzkid";
      };
      "jazznode" = {
        HostName = "exit-node.jazzkid.xyz";
        User = "exit-node";
      };
    };
  };
}

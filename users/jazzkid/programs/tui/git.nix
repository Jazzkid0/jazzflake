_: {
  programs.git = {
    enable = true;
    signing.format = null;
    settings = {
      safe = {
        directory = "/etc/nixos";
      };
      credential."https://github.com" = {
        useHttpPath = true;
      };
      init = {
        defaultBranch = "main";
      };
    };
  };
}

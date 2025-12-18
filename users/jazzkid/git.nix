{ ... }:
{
  programs.git = {
    enable = true;
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

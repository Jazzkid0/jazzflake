{pkgs, ...}: {
  programs.opencode = {
    enable = true;
    package = pkgs.opencode;
    tools = {};
    agents = {};
    skills = {};
    context = "";
    themes = {};
    tui = {};
    commands = {};
    enableMcpIntegration = false;
    settings = {};
    web = {
      enable = true;
      environmentFile = null;
      extraArgs = [
        "--port"
        "32123"
      ];
    };
  };
}

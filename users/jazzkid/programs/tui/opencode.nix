{pkgs, opencodeEnvironmentFile ? null, ...}: {
  programs.opencode = {
    enable = true;
    package = pkgs.opencode;
    tools = {};
    agents = {};
    skills = {};
    context = "";
    themes = {};
    commands = {};
    enableMcpIntegration = false;
    settings = {
      shell = "zsh";
      server.port = 32123;
      instructions = ["AGENTS.md" ".agents/"];
      model = "deepseek/deepseek-v4-pro";
      small_model = "deepseek/deepseek-v4-flash";
      plugin = [
        "superpowers@git+https://github.com/obra/superpowers.git#f2cbfbefebbfef77321e4c9abc9e949826bea9d7"
      ];

      mcp = {
        context7 = {
          type = "remote";
          url = "https://mcp.context7.com/mcp";
          enabled = true;
        };
      };
    };
    tui = {
      theme = "dark";
      scroll_speed = 5;
    };
    # WARN: This currently means the web server runs on all hosts with user = jazzkid
    # TODO: Fix to only run on specified hosts
    web = {
      enable = true;
      environmentFile = opencodeEnvironmentFile;
      extraArgs = [];
    };
  };
}

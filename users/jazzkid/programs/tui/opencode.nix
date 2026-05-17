{
  pkgs,
  opencodeEnvironmentFile ? null,
  ...
}: {
  programs.opencode = {
    enable = true;
    package = pkgs.opencode;
    tools = {};
    agents = {};
    skills = {};
    context = ''
      # AGENTS.md

      ## North Star
      scientific method only. form a hypothesis you can test, and then test it.

      ## System Information
      this is a nixos system.
      that means that there is no linker for running binaries.

      flake.nix should handle all package imports, and also output all repo commands, devshells and package outputs

      ## CLI Tools
      command didn't work?
      check the version and use the help command before trying anything else.

      favour rust-based tools
      no grep. use rg
      no find. use fd

      agents are prohibited from `rm`ing any files.
      if a file isn't needed, notify the user when you are done with your other work.

      ## VCS
      use jujutsu VCS `jj` for all version control actions
      all `git` commands are prohibited
      all potentially destructive `jj` commands are also prohibited, such as `rebase`, `squash`, `abandon`, `git`

      ### History Safety
      VCS history must be preserved.
      This is to ensure nothing is lost, and to keep all contributors accountable for their edits.
      NEVER perform destructive operations on git or jj history. This includes:
      - Never force push or delete remote branches/tags
      - Never hard reset, amend commits, or rewrite published history
      - Never run rebase with destructive flags
      - Never abandon jj changes without explicit user confirmation
      - Never delete .git or .jj directories
      - Never run git clean, stash drop, or reflog operations
      - If a command might alter or destroy commit history, STOP and ask first
      ALWAYS prefer putting your changes on top of the current history.

      Inform the user of why and how the history should be cleaned up after you are finished with your task.
    '';
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

      permission = {
        bash = {
          "*" = "ask";
          "rm*" = "deny";

          "ls*" = "allow";
          "grep*" = "deny";
          "rg*" = "allow";
          "find*" = "deny";
          "fd*" = "allow";

          # Git: read-only only — use jj for all history operations
          "git*" = "deny";

          # JJ: deny destructive history operations
          "jj git*" = "deny";
          "jj squash*" = "deny";
          "jj abandon*" = "deny";
          "jj rebase*" = "deny";
          "jj describe --reset*" = "deny";

          "jj log*" = "allow";
          "jj status*" = "allow";
          "jj diff*" = "allow";
          "jj op log*" = "allow";
          "jj evolog*" = "allow";
          "jj new*" = "allow";
          "jj split*" = "allow";
        };
      };

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

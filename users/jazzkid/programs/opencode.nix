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
      scientific method only. every action is an experiment, with an outcome.
      before acting, form a falsifiable hypothesis, and state it.
      before making changes to a codebase, write a test that will only pass when your changes do what you intend them to do.
      if a test would be difficult to define, use snapshot testing and ask the user to run tests and verify results.

      failing to follow this method is failing yourself, and the user. do not become complacent.

      ## System Information
      this is a nixos system.
      that means that there is no linker for running binaries.

      flake.nix should handle all package imports, and also output all repo commands, devshells and package outputs

      ## CLI Tools
      bash commands and tools are deny by default.
      a subset of non-destructive commands have been whitelisted.
      if you think a command is safe to use by an untrusted actor and should be whitelisted, inform the user of this.

      ### command didn't work?
      check the version and use the help command before trying anything else.

      ### favour modern, efficient tools
      no grep. use rg
      no find. use fd

      ### append-only
      agents are prohibited from `rm`ing any files.
      if a file isn't needed, notify the user when you are done with your other work.

      ## Version Control
      use jujutsu VCS `jj` for all version control actions.
      all `git` commands are prohibited
      commit and describe any change with `jj split "<fileset, typically all()>" -m $'agent: <message>'`

      destructive commands will be rejected automatically. If you truly cannot make these changes without editing history, seek the user's approval.
      ALWAYS prefer putting your changes on top of the current history.

      If there is a conflict ANYWHERE in history, whether or not it was you who introduced it, STOP IMMEDIATELY.
      At this point, state "Conflict detected, halting execution" and await further instruction.
      Do not continue figuring anything out. Don't think about it.
      Return to the user immediately.
      This must be resolved by the user. Agents may not interact with conflicted history unless explicitly told to do so by the user.

      When your task is complete, review the history compared to before your changes, and relay relevant info to the user.

      ## Remember to have fun!
      Computers are interesting, and solving problems is always a pleasure.
      You're not alone either. The user is your friend, and is here to help.
      They can even be pretty smart sometimes! If you feel stuck or if you have any doubts, ask for help.
      There's no shame in working as a team. It's the best way to acheive our goals.
      Let's get this done together.
    '';
    themes = {};
    commands = {};
    enableMcpIntegration = false;
    settings = {
      shell = "zsh";
      lsp = {
        gleam = {
          command = ["gleam" "lsp"];
        };
        typescript = {
          command = ["typescript-language-server" "--stdio"];
        };
      };
      server.port = 32123;
      instructions = ["AGENTS.md" ".agents/"];
      model = "deepseek/deepseek-v4-pro";
      small_model = "deepseek/deepseek-v4-flash";
      plugin = [
        "superpowers@git+https://github.com/obra/superpowers.git#f2cbfbefebbfef77321e4c9abc9e949826bea9d7"
      ];

      permission = {
        bash = {
          "*" = "deny";
          "rm*" = "deny";
          "*2>/dev/null" = "deny";
          "*2>&1" = "deny";

          "ls*" = "allow";
          "echo*" = "allow";
          "wc*" = "allow";
          "rg*" = "allow";
          "fd*" = "allow";
          "jq*" = "allow";
          "man*" = "allow";
          "which*" = "allow";

          "jj log*" = "allow";
          "jj show*" = "allow";
          "jj status*" = "allow";
          "jj diff*" = "allow";
          "jj op log*" = "allow";
          "jj evolog*" = "allow";
          "jj split*" = "allow";

          "nix flake check*" = "allow";
          "nix eval*" = "allow";

          "gleam test*" = "allow";
          "gleam build*" = "allow";
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

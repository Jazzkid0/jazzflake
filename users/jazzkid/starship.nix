{ ... }:
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      add_newline = false;

      format = ''
        $username$hostname $directory$git_branch''${env_var.FLAKE_DESC}$character
      '';

      right_format = "$cmd_duration$time";

      env_var.FLAKE_DESC = {
        format = "[$env_value]($style)";
        style = "bold dimmed blue";
      };

      nix_shell = {
        format = "[$symbol$state( ($name))]($style) ";
        symbol = "";
        style = "bold blue";
        impure_msg = "impure";
        pure_msg = "pure";
        unknown_msg = "";
        disabled = false;
        heuristic = false;
      };

      username = {
        disabled = false;
        show_always = true;
        format = "[$user]($style)";
        style_user = "yellow";
        style_root = "bold red";
      };

      hostname = {
        disabled = false;
        ssh_only = false;
        format = "[@$hostname]($style)";
        style = "yellow";
      };

      directory = {
        style = "green";
        truncation_length = 8;
        read_only = "";
      };

      character = {
        success_symbol = "[>](green)";
        error_symbol = "[>](red)";
        vimcmd_symbol = "[V](bold blue)";
      };

      package = {
        disabled = true;
      };

      git_branch = {
        format = "[\\(($branch(:$remote_branch))\\)]($style) ";
        style = "red";
      };

      time = {
        disabled = false;
        format = "- [$time]($style)";
        style = "bright white";
      };
    };
  };
}

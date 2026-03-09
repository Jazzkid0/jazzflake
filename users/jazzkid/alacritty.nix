{ lib, pkgs, ... }:

{
  programs.alacritty = {
    enable = true;

    settings = {
      env = {
        TERM = "xterm-256color";
      };

      terminal.shell = "zsh";

      font = {
        normal = {
          family = "RobotoMono Nerd Font";
        };
        size = 14.0;
      };

      window = {
        opacity = 1.0;
        padding = {
          x = 8;
          y = 8;
        };
      };

      colors = {
        primary = {
          foreground = "#c0caf5";
          background = "#000000";
        };

        normal = {
          black = "#15161e";
          red = "#f7768e";
          green = "#9ece6a";
          yellow = "#e0af68";
          blue = "#7aa2f7";
          magenta = "#bb9af7";
          cyan = "#7dcfff";
          white = "#a9b1d6";
        };

        bright = {
          black = "#414868";
          red = "#f7768e";
          green = "#9ece6a";
          yellow = "#e0af68";
          blue = "#7aa2f7";
          magenta = "#bb9af7";
          cyan = "#7dcfff";
          white = "#c0caf5";
        };
      };

      keyboard.bindings = [
        {
          key = "Space";
          mods = "Control";
          chars = "\u0000";
        }
        {
          key = "V";
          mods = "Control|Shift";
          action = "Paste";
        }
        {
          key = "C";
          mods = "Control|Shift";
          action = "Copy";
        }
        {
          key = "Paste";
          action = "Paste";
        }
        {
          key = "Copy";
          action = "Copy";
        }
        {
          key = "L";
          mods = "Control";
          action = "ReceiveChar";
        }
        {
          key = "Insert";
          mods = "Shift";
          action = "ReceiveChar";
        }
      ];
    };
  };
}

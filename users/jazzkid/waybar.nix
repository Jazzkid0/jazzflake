{pkgs, ...}: let
  makoWaybarScript = pkgs.writeShellScript "mako-dnd" ''
    if ${pkgs.mako}/bin/makoctl mode | grep -q "do-not-disturb"; then
      echo '{"text": "󰂛", "tooltip": "Do not disturb", "class": "dnd"}'
    else
      echo '{"text": "󰂚", "tooltip": "Notifications on", "class": "active"}'
    fi
  '';
in {
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "bottom";
        height = 30;
        modules-left = ["hyprland/workspaces"];
        modules-center = ["hyprland/window"];
        modules-right = ["custom/mako-dnd" "pulseaudio" "tray" "network" "clock"];

        clock = {
          format = "{:%Y-%m-%d | %H:%M}";
          format-alt = "{:%Y-%m-%d}";
          tooltip-format = "{:%Y-%m-%d | %H:%M}";
          interval = 1;
        };

        network = {
          format-wifi = "󰤨 {signalStrength}%";
          format-ethernet = "󰈀";
          format-disconnected = "󰤭";
          format-alt = "{ifname}: {ipaddr}";
          tooltip-format = "{ifname}: {ipaddr}";
          interval = 5;
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "󰝟";
          format-icons = {
            default = ["󰕿" "󰖀" "󰕾"];
          };
          on-click = "pavucontrol";
          tooltip-format = "{desc}, {volume}%";
        };

        "hyprland/workspaces" = {
          format = "{icon}: {windows}";
          format-window-separator = " | ";
          window-rewrite-default = "?";
          disable-scroll = false;
          all-outputs = false;
          persistent-workspaces = {
            "*" = 8;
          };
          workspace-taskbar = {
            enable = true;
            update-active-window = true;
            format = "{icon} {title:.20}";
            icon-size = 14;
            orientation = "horizontal";
          };
        };

        "hyprland/window" = {
          format = "{}";
          max-length = 50;
          separate-outputs = true;
        };

        "custom/mako-dnd" = {
          exec = "${makoWaybarScript}";
          return-type = "json";
          interval = "once";
          signal = 1;
          on-click = "${pkgs.mako}/bin/makoctl mode -t do-not-disturb && ${pkgs.mako}/bin/makoctl reload && ${pkgs.procps}/bin/pkill -RTMIN+1 waybar";
          exec-if = "${pkgs.mako}/bin/makoctl --version";
        };
      };
    };

    style = ''
      * {
        font-family: "RobotoMono Nerd Font";
        font-size: 14px;
      }
      window#waybar {
        background: rgba(30, 30, 46, 0.9);
        color: #cdd6f4;
      }
      #workspaces button {
        padding: 0 5px;
        color: #cdd6f4;
      }
      #workspaces button.active {
        color: #a6e3a1;
      }
      #workspaces .workspace-label {
        padding-left: 3px;
      }
      #workspaces .taskbar-window {
        font-weight: normal;
        padding-left: 5px;
        padding-right: 5px;
      }
      #workspaces .taskbar-window.active {
        background-color: rgba(166, 227, 161, 0.2);
      }
      #clock {
        padding: 0 10px;
        background: #cdd6f4;
        color: #32290b;
      }
      #network, #pulseaudio {
        padding: 0 10px;
        color: #cdd6f4;
      }
    '';
  };
}

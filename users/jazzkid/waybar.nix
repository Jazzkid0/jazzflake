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
      };

      clock = {
        format = "{:%Y-%m-%d | %H:%M}";
        format-alt = "{:%Y-%m-%d}";
        tooltip-format = "{:%Y-%m-%d | %H:%M}";
        interval = 1;
      };

      battery = {
        states = {
          warning = 30;
          critical = 15;
        };
        format = "{icon} {capacity}%";
        format-icons = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
        format-charging = " {capacity}%";
        format-plugged = " {capacity}%";
        format-alt = "{icon} {time}";
        tooltip-format = "{timeTo}, {capacity}%";
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
        disable-scroll = false;
        all-outputs = false;
        format = "{icon}";
        format-icons = {
          "1" = "一";
          "2" = "二";
          "3" = "三";
          "4" = "四";
          "5" = "五";
          "6" = "六";
          "7" = "七";
          "8" = "八";
          "9" = "九";
          "10" = "十";
        };
        persistent-workspaces = {
          "*" = [];
        };
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
      #clock {
        padding: 0 10px;
        background: #cdd6f4;
        color: #32290b;
      }
      #battery, #network, #pulseaudio {
        padding: 0 10px;
        color: #cdd6f4;
      }
      #battery.warning {
        color: #f9e2af;
      }
      #battery.critical {
        color: #f38ba8;
      }
    '';
  };
}

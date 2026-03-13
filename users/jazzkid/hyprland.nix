{ lib, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;

    settings = {
      "$mod" = "SUPER";
      
      # TODO: monitor settings
      #monitor = ",preferred,auto,1"

      exec-once = [
      ];

      general = {
        gaps_in = 4;
        gaps_out = 8;
        border_size = 2;
      };

      decoration = {
        rounding = 8;
        blur = {
          enabled = true;
          size = 4;
          passes = 1;
        };
      };

      animations.enabled = false;

      input = {
        kb_layout = "us";
        # kb_variant = "hillside48"; # unlikely to be supported?
        # kb_options = ""; # maybe I can fix my pound sign button idk
        follow_mouse = 1;
        sensitivity = 0;
        touchpad = {
          natural_scroll = true;
          tap-to-click = true;
        };
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        force_default_wallpaper = 0;
      };

      # FORMAT: "Mods, key, dispatcher, params"
      bind = [
        # Exit / Kill
        "$mod SHIFT, K, exit"
        "$mod, K, killactive"
        "$mod CONTROL, K, forcekillactive"

        # Launcher / Terminal
        "$mod, D, exec, wofi"
        "$mod, H, exec, alacritty"

        "$mod, V, exec, cliphist list | wofi --dmenu | cliphist decode"
        "$mod SHIFT, V, exec, cliphist store"
        # Window management
        "$mod, F, fullscreen"
        "$mod SHIFT, F, togglefloating"

        # Workspace navigation (Colemak: arst = 1-4, neio = 5-9)
        "$mod, A, workspace, 1"
        "$mod, R, workspace, 2"
        "$mod, S, workspace, 3"
        "$mod, T, workspace, 4"
        "$mod, N, workspace, 5"
        "$mod, E, workspace, 6"
        "$mod, I, workspace, 7"
        "$mod, O, workspace, 8"

        # Move window to workspace (Colemak)
        "$mod SHIFT, A, movetoworkspace, 1"
        "$mod SHIFT, R, movetoworkspace, 2"
        "$mod SHIFT, S, movetoworkspace, 3"
        "$mod SHIFT, T, movetoworkspace, 4"
        "$mod SHIFT, N, movetoworkspace, 5"
        "$mod SHIFT, E, movetoworkspace, 6"
        "$mod SHIFT, I, movetoworkspace, 7"
        "$mod SHIFT, O, movetoworkspace, 8"

        # Move focus (direction - hjkl / arrows)
        "$mod, H, movefocus, l"
        "$mod, J, movefocus, d"
        "$mod, K, movefocus, u"
        "$mod, L, movefocus, r"
        "$mod, Left, movefocus, l"
        "$mod, Right, movefocus, r"
        "$mod, Up, movefocus, u"
        "$mod, Down, movefocus, d"

        # Move window (direction - hjkl / arrows)
        "$mod SHIFT, H, movewindow, l"
        "$mod SHIFT, J, movewindow, d"
        "$mod SHIFT, K, movewindow, u"
        "$mod SHIFT, L, movewindow, r"
        "$mod SHIFT, Left, movewindow, l"
        "$mod SHIFT, Right, movewindow, r"
        "$mod SHIFT, Up, movewindow, u"
        "$mod SHIFT, Down, movewindow, d"

        # Special workspace (scratchpad)
        "$mod, X, togglespecialworkspace, magic"

        # Mouse emulation (alt + hjkl to move focus)
        "$mod, Alt, movefocus, l"
        "$mod, Alt, movefocus, d"
        "$mod, Alt, movefocus, u"
        "$mod, Alt, movefocus, r"

        # Scroll through workspaces
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"

        # Media keys (XF86 codes - universal)
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86MonBrightnessUp, exec, brightnessctl set +5%"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
      ];

      # Mouse bindings
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      # Window rules
      windowrules = [
        "match:class ^(pavucontrol)$, float"
        "match:class ^(nm-connection-editor)$, float"
        "match:title ^(Open File)$, float"
        "match:title ^(Save File)$, float"
      ];
      
    };

    extraConfig = ''
      # Custom additional config
    '';
  };
}

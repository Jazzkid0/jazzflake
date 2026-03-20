{ pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;

    settings = {
      # TODO: monitor settings
      #monitor = ",preferred,auto,1"

      exec-once = [
        "${pkgs.waybar}/bin/waybar"
        "${pkgs.mako}/bin/mako"
        "wl-paste --type text --watch cliphist store" # Stores only text data
        "wl-paste --type image --watch cliphist store" # Stores only image data

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
        "SUPER SHIFT, K, exit"
        "SUPER, K, killactive"
        "SUPER CONTROL, K, forcekillactive"

        ## PROGRAMS $$

        # Launcher / Terminal
        "SUPER, D, exec, wofi --show drun"
        "SUPER SHIFT, D, exec, wofi --show run"
        "SUPER, H, exec, alacritty"

        "SUPER, V, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy"
        "SUPER, V, exec, cliphist list | wofi --dmenu --pre-display-cmd \"echo '%s' | cut -f 2\" | cliphist decode | wl-copy"
        "SUPER SHIFT, V, exec, cliphist store"


        ## NAVIGATION ##

        # Window management
        "SUPER, F, fullscreen"
        "SUPER ALT, F, fullscreen" # TODO: Maximise window?
        "SUPER SHIFT, F, togglefloating"

        # Workspace navigation (Colemak: arst = 1-4, neio = 5-9)
        "SUPER, A, workspace, 1"
        "SUPER, R, workspace, 2"
        "SUPER, S, workspace, 3"
        "SUPER, T, workspace, 4"
        "SUPER, N, workspace, 5"
        "SUPER, E, workspace, 6"
        "SUPER, I, workspace, 7"
        "SUPER, O, workspace, 8"

        # Move window to workspace (Colemak)
        "SUPER SHIFT, A, movetoworkspace, 1"
        "SUPER SHIFT, R, movetoworkspace, 2"
        "SUPER SHIFT, S, movetoworkspace, 3"
        "SUPER SHIFT, T, movetoworkspace, 4"
        "SUPER SHIFT, N, movetoworkspace, 5"
        "SUPER SHIFT, E, movetoworkspace, 6"
        "SUPER SHIFT, I, movetoworkspace, 7"
        "SUPER SHIFT, O, movetoworkspace, 8"

        # Move focus (direction - hjkl / arrows)
        "SUPER CONTROL, H, movefocus, l"
        "SUPER CONTROL, J, movefocus, d"
        "SUPER CONTROL, K, movefocus, u"
        "SUPER CONTROL, L, movefocus, r"
        "SUPER, Left, movefocus, l"
        "SUPER, Right, movefocus, r"
        "SUPER, Up, movefocus, u"
        "SUPER, Down, movefocus, d"
        "SUPER CONTROL, Left, movefocus, l"
        "SUPER CONTROL, Right, movefocus, r"
        "SUPER CONTROL, Up, movefocus, u"
        "SUPER CONTROL, Down, movefocus, d"

        # Move window (direction - hjkl / arrows)
        "SUPER SHIFT, H, movewindow, l"
        "SUPER SHIFT, J, movewindow, d"
        "SUPER SHIFT, K, movewindow, u"
        "SUPER SHIFT, L, movewindow, r"
        "SUPER SHIFT, Left, movewindow, l"
        "SUPER SHIFT, Right, movewindow, r"
        "SUPER SHIFT, Up, movewindow, u"
        "SUPER SHIFT, Down, movewindow, d"

        # Special workspace (scratchpad)
        "SUPER, X, togglespecialworkspace, magic"

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
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
        "SUPER, mouse:274, fullscreen"
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

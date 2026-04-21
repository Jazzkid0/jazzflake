{pkgs, ...}: let
  workspaceIndicator =
    pkgs.writeShellScriptBin "workspace-indicator"
    ''
      hyprctl notify -1 800 "rgb(a6e3a1)" "fontsize:36  $1 "
      hyprctl dispatch workspace "$1"
    '';
  moveToWorkspace =
    pkgs.writeShellScriptBin "move-to-workspace"
    ''
      hyprctl notify -1 800 "rgb(a6e3a1)" "fontsize:36  $1 "
      hyprctl dispatch movetoworkspace "$1"
    '';
in {
  home.packages = [workspaceIndicator moveToWorkspace];

  services.hyprpolkitagent.enable = true;

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
        "${pkgs.cursor-clip}/bin/cursor-clip --daemon"
      ];

      general = {
        gaps_in = 4;
        gaps_out = 8;
        border_size = 2;
        layout = "scrolling";
      };

      scrolling = {
        direction = "right";
        fullscreen_on_one_column = true;
        column_width = 0.8;
        focus_fit_method = 1;
        follow_focus = true;
        follow_min_visible = 0.4;
        explicit_column_widths = "0.333, 0.5, 0.667, 1.0";
      };

      decoration = {
        rounding = 8;
        blur = {
          enabled = false;
        };
      };

      animations = {
        enabled = true;
        bezier = "snap, 0.4, 0, 0.8, 1";
        animation = [
          "workspaces, 1, 0.5, snap, slidefade 8%"
          "windows, 1, 0.5, snap, slide"
          "windowsIn, 1, 1, snap, popin 80%"
          "windowsOut, 1, 0.5, snap, popin 80%"
          "fade, 1, 0.5, default"
          "border, 1, 0.5, default"
          "specialWorkspace, 1, 0.5, snap, slidefadevert 8%"
        ];
      };

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
        "SUPER SHIFT, K, exec, ${pkgs.hyprshutdown}/bin/hyprshutdown --post-cmd 'shutdown now'"
        "SUPER, K, killactive"
        "SUPER CONTROL, K, forcekillactive"

        ## PROGRAMS ##

        # Launcher / Terminal
        "SUPER, D, exec, ${pkgs.tofi}/bin/tofi-drun"
        "SUPER SHIFT, D, exec, ${pkgs.tofi}/bin/tofi-run"
        "SUPER, H, exec, ${pkgs.alacritty}/bin/alacritty"

        "SUPER, V, exec, ${pkgs.cursor-clip}/bin/cursor-clip"
        "SUPER SHIFT, V, exec, ${pkgs.cursor-clip}/bin/cursor-clip"

        "SUPER, Q, exec, ${pkgs.mako}/bin/makoctl mode -t do-not-disturb && ${pkgs.mako}/bin/makoctl reload && ${pkgs.procps}/bin/pkill -RTMIN+1 waybar"

        ## NAVIGATION ##

        # Window management
        "SUPER, F, fullscreen"
        "SUPER ALT, F, fullscreen" # TODO: Maximise window?
        "SUPER SHIFT, F, togglefloating"

        # Workspace navigation (Colemak: arst = 1-4, neio = 5-9)
        "SUPER, A, exec, workspace-indicator 1"
        "SUPER, R, exec, workspace-indicator 2"
        "SUPER, S, exec, workspace-indicator 3"
        "SUPER, T, exec, workspace-indicator 4"
        "SUPER, N, exec, workspace-indicator 5"
        "SUPER, E, exec, workspace-indicator 6"
        "SUPER, I, exec, workspace-indicator 7"
        "SUPER, O, exec, workspace-indicator 8"

        # Move window to workspace (Colemak)
        "SUPER SHIFT, A, exec, move-to-workspace 1"
        "SUPER SHIFT, R, exec, move-to-workspace 2"
        "SUPER SHIFT, S, exec, move-to-workspace 3"
        "SUPER SHIFT, T, exec, move-to-workspace 4"
        "SUPER SHIFT, N, exec, move-to-workspace 5"
        "SUPER SHIFT, E, exec, move-to-workspace 6"
        "SUPER SHIFT, I, exec, move-to-workspace 7"
        "SUPER SHIFT, O, exec, move-to-workspace 8"

        # Move focus (columns via layoutmsg, rows via movefocus)
        "SUPER CONTROL, H, layoutmsg, focus l"
        "SUPER CONTROL, J, movefocus, d"
        "SUPER CONTROL, K, movefocus, u"
        "SUPER CONTROL, L, layoutmsg, focus r"
        "SUPER, Left, layoutmsg, focus l"
        "SUPER, Right, layoutmsg, focus r"
        "SUPER, Up, movefocus, u"
        "SUPER, Down, movefocus, d"
        "SUPER CONTROL, Left, layoutmsg, focus l"
        "SUPER CONTROL, Right, layoutmsg, focus r"
        "SUPER CONTROL, Up, movefocus, u"
        "SUPER CONTROL, Down, movefocus, d"

        # Swap columns (via layoutmsg) / move window in column
        "SUPER SHIFT, H, layoutmsg, swapcol l"
        "SUPER SHIFT, J, movewindow, d"
        "SUPER SHIFT, K, movewindow, u"
        "SUPER SHIFT, L, layoutmsg, swapcol r"
        "SUPER SHIFT, Left, layoutmsg, swapcol l"
        "SUPER SHIFT, Right, layoutmsg, swapcol r"
        "SUPER SHIFT, Up, movewindow, u"
        "SUPER SHIFT, Down, movewindow, d"

        # Special workspace (scratchpad)
        "SUPER, X, togglespecialworkspace, magic"
        "SUPER SHIFT, X, movetoworkspace, special:magic"

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

        # Scroll horizontally in column layout
        "SUPER, mouse_down, cyclenext"
        "SUPER, mouse_up, cyclenext, prev"
      ];

      # Mouse bindings for window actions
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

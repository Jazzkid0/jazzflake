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
        "waybar"
        "foot"
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
        # kb_variant = "";
        # kb_options = "grp:alt_space_toggle";
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
        "$mod SHIFT, K, exit"
        "$mod, K, killactive"
        "$mod, H, foot"
        "$mod, F, fullscreen"
        "$mod SHIFT, F, togglefloating"

        # Applications: foot
        # workspace: mod arst, neio (colemak mdh home row)
        # movetoworkspace: +shift
        # specialworkspace: mod x, move to with shift
        # movefocus: mod lrud, hjkl
        # movewindow: +shift
        # Media keys
      ];
    };

    extraConfig = ''
      # Custom additional config
    '';
  };
}

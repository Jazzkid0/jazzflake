{pkgs, ...}: let
  powerMenu =
    pkgs.writeShellScriptBin "power-menu"
    ''
      action=$(printf "Preview\nExit hyprland\nExit ly\nReboot\nShutdown" | ${pkgs.tofi}/bin/tofi --prompt-text "Power: ")
      [ -z "$action" ] && exit
      case "$action" in
        "Preview") ${pkgs.hyprshutdown}/bin/hyprshutdown --dry-run ;;
        *)
          confirm=$(printf "Yes\nNo" | ${pkgs.tofi}/bin/tofi --prompt-text "$action? ")
          [ "$confirm" != "Yes" ] && exit
          case "$action" in
            "Exit hyprland") ${pkgs.hyprshutdown}/bin/hyprshutdown ;;
            "Exit ly") ${pkgs.hyprshutdown}/bin/hyprshutdown --post-cmd 'loginctl terminate-user $USER' ;;
            "Reboot") ${pkgs.hyprshutdown}/bin/hyprshutdown --post-cmd 'systemctl reboot' ;;
            "Shutdown") ${pkgs.hyprshutdown}/bin/hyprshutdown --post-cmd 'systemctl poweroff' ;;
          esac
          ;;
      esac
    '';
  launcher =
    pkgs.writeShellScriptBin "launcher"
    ''
      cmd=$(${pkgs.tofi}/bin/tofi-drun)
      [ -n "$cmd" ] && hyprctl dispatch "hl.dsp.exec_cmd(\"$cmd\")"
    '';
  runner =
    pkgs.writeShellScriptBin "runner"
    ''
      cmd=$(${pkgs.tofi}/bin/tofi-run)
      [ -n "$cmd" ] && hyprctl dispatch "hl.dsp.exec_cmd(\"$cmd\")"
    '';
  screenshot =
    pkgs.writeShellScriptBin "screenshot"
    ''
      mkdir -p "$HOME/downloads/images"
      ${pkgs.hyprshot}/bin/hyprshot -m region -o "$HOME/downloads/images"
    '';
  dndToggle =
    pkgs.writeShellScriptBin "dnd-toggle"
    ''
      ${pkgs.mako}/bin/makoctl mode -t do-not-disturb
      ${pkgs.mako}/bin/makoctl reload
      ${pkgs.procps}/bin/pkill -RTMIN+1 waybar
    '';

  hyprlandConfig = pkgs.runCommand "hyprland.lua" {} ''
    substitute ${./hyprland.lua} $out \
      --replace-fail '@alacritty@' '${pkgs.alacritty}' \
      --replace-fail '@waybar@' '${pkgs.waybar}' \
      --replace-fail '@mako@' '${pkgs.mako}' \
      --replace-fail '@dbus@' '${pkgs.dbus}' \
      --replace-fail '@cursorClip@' '${pkgs.cursor-clip}' \
      --replace-fail '@powerMenu@' '${powerMenu}' \
      --replace-fail '@launcher@' '${launcher}' \
      --replace-fail '@runner@' '${runner}' \
      --replace-fail '@screenshot@' '${screenshot}' \
      --replace-fail '@dndToggle@' '${dndToggle}'
  '';
in {
  home.packages = [powerMenu launcher runner screenshot dndToggle];

  services.hyprpolkitagent.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    xwayland.enable = true;
    systemd.enable = true;
    extraConfig = "# config deployed via xdg.configFile";
  };

  xdg.configFile."hypr/hyprland.lua".source = hyprlandConfig;
}

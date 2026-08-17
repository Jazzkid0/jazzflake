{pkgs, ...}: let
  powerMenu =
    pkgs.writeShellScriptBin "jazz-power-menu"
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
    pkgs.writeShellScriptBin "jazz-launcher"
    ''
      cmd=$(${pkgs.tofi}/bin/tofi-drun)
      [ -n "$cmd" ] && hyprctl dispatch "hl.dsp.exec_cmd(\"$cmd\")"
    '';
  runner =
    pkgs.writeShellScriptBin "jazz-runner"
    ''
      cmd=$(${pkgs.tofi}/bin/tofi-run)
      [ -n "$cmd" ] && hyprctl dispatch "hl.dsp.exec_cmd(\"$cmd\")"
    '';
  screenshot =
    pkgs.writeShellScriptBin "jazz-screenshot"
    ''
      mkdir -p "$HOME/downloads/images"
      ${pkgs.hyprshot}/bin/hyprshot -m region -o "$HOME/downloads/images"
    '';
  dndToggle =
    pkgs.writeShellScriptBin "jazz-dnd-toggle"
    ''
      ${pkgs.mako}/bin/makoctl mode -t do-not-disturb
      ${pkgs.mako}/bin/makoctl reload
      ${pkgs.procps}/bin/pkill -RTMIN+1 waybar
    '';
  clipboardPicker =
    pkgs.writeShellScriptBin "jazz-clipboard-picker"
    ''
      set -euo pipefail

      items=$(${pkgs.copyq}/bin/copyq eval -- "tab('clipboard'); for (i = 0; i < size(); ++i) print(str(i) + '\\t' + str(read(i)).replace(/\\n/g, ' '));")
      [ -z "$items" ] && exit 0

      selected=$(printf '%s\n' "$items" | ${pkgs.tofi}/bin/tofi --prompt-text "Clipboard: ")
      [ -z "$selected" ] && exit 0

      index=''${selected%%$'\t'*}
      ${pkgs.copyq}/bin/copyq tab clipboard select "$index"
      ${pkgs.copyq}/bin/copyq paste
    '';

  hyprlandConfig = pkgs.runCommand "hyprland.lua" {} ''
    substitute ${./hyprland.lua} $out \
      --replace-fail '@alacritty@' '${pkgs.alacritty}' \
      --replace-fail '@waybar@' '${pkgs.waybar}' \
       --replace-fail '@mako@' '${pkgs.mako}' \
       --replace-fail '@dbus@' '${pkgs.dbus}' \
       --replace-fail '@copyq@' '${pkgs.copyq}' \
       --replace-fail '@clipboardPicker@' '${clipboardPicker}' \
       --replace-fail '@powerMenu@' '${powerMenu}' \
      --replace-fail '@launcher@' '${launcher}' \
      --replace-fail '@runner@' '${runner}' \
      --replace-fail '@screenshot@' '${screenshot}' \
      --replace-fail '@dndToggle@' '${dndToggle}'
  '';
in {
  home.packages = [powerMenu launcher runner screenshot dndToggle clipboardPicker];

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

{...}: {
  imports = [
    ./packages.nix
    ./fonts.nix
    ./hyprland.nix
    ./waybar.nix
    ./alacritty.nix

    ./launcher.nix

    ./screenshot.nix
    ./clipboard.nix
    ./shutdown.nix

    ./hyprpaper.nix # wallpapers
    ./mako.nix # notifs

    ./obs-studio.nix
    ./imv.nix
  ];

  gtk = {
    enable = true;
    gtk4.theme = null;
  };

  home.sessionVariables = {
    QT_QPA_PLATFORM = "wayland;xcb";
  };
}

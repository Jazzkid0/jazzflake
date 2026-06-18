{pkgs, ...}: {
  imports = [
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

  home.packages = with pkgs; [
    feishin
    thunar
    thunar-archive-plugin
    thunar-volman
    spotify
    qt5.qtwayland
    qt6.qtwayland
    vlc
    libreoffice
    losslesscut-bin
    slippi-launcher-desktop
    steam-run
    # once cache works:
    # helium
  ];

  home.sessionVariables = {
    QT_QPA_PLATFORM = "wayland;xcb";
  };
}

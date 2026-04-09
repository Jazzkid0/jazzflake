{
  pkgs,
  ...
}: {
  imports = [
    ./fonts.nix
    ./hyprland.nix
    ./waybar.nix
    ./alacritty.nix

    ./wofi.nix # launcher

    ./clipboard.nix

    ./hyprpaper.nix # wallpapers
    # ./grimblast.nix # screenshots
    ./mako.nix # notifs

    ./obs-studio.nix

    ./ollama.nix
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
    # once cache works:
    # helium
    # slippi
  ];

  home.sessionVariables = {
    QT_QPA_PLATFORM = "wayland;xcb";
  };
}

{pkgs, ...}: {
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
    slippi-netplay-beta
    steam-run
    # once cache works:
    # helium
  ];
}

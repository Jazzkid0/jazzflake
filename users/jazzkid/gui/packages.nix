{pkgs, inputs, ...}: {
  home.packages = with pkgs; [
    feishin
    thunar
    thunar-archive-plugin
    thunar-volman
    inputs.self.packages.x86_64-linux.helium
    spotify
    qt5.qtwayland
    qt6.qtwayland
    vlc
    libreoffice
    losslesscut-bin
    slippi-launcher-desktop
    slippi-netplay-beta
    steam-run
  ];
}

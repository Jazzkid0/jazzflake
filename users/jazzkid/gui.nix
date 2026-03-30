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
    # polkid-kde-agent or lxqt-policykit # allow gui apps to request elevated permissions

    # ./slippi-launcher.nix (cache may have to handle this)

    # ./hyprpaper.nix # wallpapers
    # ./yazi.nix # file manager (terminal based?)
    # ./grimblast.nix # screenshots
    ./mako.nix # notifs

    # how do I install things like helium-browser? It's released as a .appimage, and there's also a third party flake that builds it at github:AlvaroParker/helium-nix .
    # if possible, I'd like to avoid running third-party code. Maybe I could build manually using the flake.nix in that repo as reference.
    ./ollama.nix
  ];

  gtk = {
    enable = true;
    gtk4.theme = null;
  };

  home.packages = with pkgs; [
    feishin
    obs-studio
    thunar
    thunar-archive-plugin
    thunar-volman
    spotify
  ];
}

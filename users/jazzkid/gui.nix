{
  config,
  lib,
  ...
}: {
  imports = [
    ./fonts.nix
    ./hyprland.nix
    ./waybar.nix
    # still deciding on a terminal, install both for now
    ./alacritty.nix
    # ./ghostty.nix

    ./wofi.nix # launcher
    ./clipboard.nix
    # polkid-kde-agent or lxqt-policykit # allow gui apps to request elevated permissions

    # some kind of media player

    # slippi melee, deps like dolphin

    # ./hyprpaper.nix # wallpapers
    # ./yazi.nix # file manager (terminal based?)
    # ./grimblast.nix # screenshots
    ./mako.nix # notifs

    # how do I install things like helium-browser? It's released as a .appimage, and there's also a third party flake that builds it at github:AlvaroParker/helium-nix .
    # if possible, I'd like to avoid running third-party code. Maybe I could build manually using the flake.nix in that repo as reference.
  ];

  gtk.enable = true;
}

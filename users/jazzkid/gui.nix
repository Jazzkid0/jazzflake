{ config, lib, ... }:
{
  imports = [
      ./hyprland.nix
      ./waybar.nix
      # still deciding on a terminal, install both for now
      # ./alacritty.nix
      # ./ghostty.nix
      # need to get a monospaced nerd font on this system, I prefer roboto mono

      # not familiar with common programs, but these have been recommended to me
      # ./hyprpaper.nix # wallpapers
      ./wofi.nix # launcher
      # ./yazi.nix # file manager (terminal based?)
      # polkid-kde-agent or lxqt-policykit # allow gui apps to request elevated permissions
      # cliphist + wl-clipboard # clipboard
      # (check pipewire + wireplumber) # haven't tested audio yet
      # ./grimblast.nix # screenshots
      # ./mako.nix # notifs

      # how do I install things like helium-browser? It's released as a .appimage, and there's also a third party flake that builds it at github:AlvaroParker/helium-nix .
      # if possible, I'd like to avoid running third-party code. Maybe I could build manually using the flake.nix in that repo as reference.
    ];

    gtk.enable = true;
}

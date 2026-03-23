{
  pkgs,
  lib,
  gui,
  unfree-whitelist,
  ...
}: {
  imports =
    [
      ./networking.nix
      ./security.nix
      ./nginx.nix
    ]
    ++ lib.optionals gui [./gui.nix]
    ++ lib.optionals unfree-whitelist [./unfree-whitelist.nix];

  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";

  nix.settings.experimental-features = ["nix-command" "flakes"];

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    ripgrep
    htop
    tmux
  ];
}

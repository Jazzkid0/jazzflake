{
  user,
  inputs,
  pkgs,
  home-manager,
  lib,
  gui,
  ...
}: {
  imports =
    [
      home-manager.nixosModules.home-manager
      ./users.nix
      ./networking.nix
      ./security.nix
      ./nginx.nix
      ./unfree-whitelist.nix
    ]
    ++ lib.optionals gui [./gui.nix];

  home-manager = {
    useGlobalPkgs = true;
    extraSpecialArgs = {inherit inputs gui;};
    users.${user} = import ../../users/${user}/home.nix;
  };

  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";

  nix.settings.experimental-features = ["nix-command" "flakes"];

  environment.systemPackages = with pkgs; [
    vim
    ripgrep
    htop
    tmux
  ];
}

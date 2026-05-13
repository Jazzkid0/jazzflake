{
  user,
  inputs,
  pkgs,
  home-manager,
  lib,
  gui,
  config,
  ...
}: {
  imports =
    [
      home-manager.nixosModules.home-manager
      ./networking.nix
      ./security.nix
      ./nginx.nix
      ./unfree-whitelist.nix
    ]
    ++ lib.optionals gui [./gui.nix];

  home-manager = {
    useGlobalPkgs = true;
    extraSpecialArgs = {
      inherit inputs user gui;
      opencodeEnvironmentFile = config.age.secrets.opencode-env.path or null;
    };
    users.${user} = import ../../users/${user}/home.nix;
  };

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

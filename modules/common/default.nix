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
      ./core.nix
      home-manager.nixosModules.home-manager
      ./security.nix
      ./nginx.nix
      ./node-exporter.nix
      ./unfree-whitelist.nix
    ]
    ++ lib.optionals gui [./gui.nix];

  nixpkgs.overlays = [
    (import ../../packages/overlay.nix)
  ];

  home-manager = {
    useGlobalPkgs = true;
    extraSpecialArgs = {
      inherit inputs user gui;
      opencodeEnvironmentFile = config.age.secrets.opencode-env.path or null;
    };
    users.${user} = import ../../users/${user}/home.nix;
  };

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    htop
    tmux
  ];
}

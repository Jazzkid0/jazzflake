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
    ++ lib.optionals gui [
      ./gui.nix
      inputs.stylix.nixosModules.stylix
    ];

  nixpkgs.overlays = [
    (import ../../packages/overlay.nix)
  ];

  home-manager = {
    useGlobalPkgs = true;
    extraSpecialArgs = {
      inherit inputs user gui;
      opencodeEnvironmentFile = config.age.secrets.opencode-env.path or null;
    };
    sharedModules = lib.optionals gui [
      inputs.stylix.homeModules.stylix
    ];
    users.${user} = import ../../users/${user}/home.nix;
  };

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    htop
    tmux
  ];
}

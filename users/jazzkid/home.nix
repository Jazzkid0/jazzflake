{
  lib,
  gui,
  ...
}: {
  imports =
    [
      ./programs.nix
      ./packages.nix
    ]
    ++ lib.optionals gui [
      ./gui.nix
    ];

  home.username = "jazzkid";
  home.homeDirectory = "/home/jazzkid";

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
}

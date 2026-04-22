{
  lib,
  gui,
  ...
}: {
  imports =
    [
      ./programs/tui
      ./packages.nix
    ]
    ++ lib.optionals gui [
      ./programs/gui
    ];

  home.username = "jazzkid";
  home.homeDirectory = "/home/jazzkid";

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
}

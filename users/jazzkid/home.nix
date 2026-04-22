{
  lib,
  user,
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

  home.username = user;
  home.homeDirectory = "/home/${user}";

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
}

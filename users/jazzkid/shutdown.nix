{pkgs, ...}: {
  home.packages = with pkgs; [
    hyprshutdown
  ];
}

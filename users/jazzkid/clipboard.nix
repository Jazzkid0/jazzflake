{pkgs, ...}: {
  home.packages = with pkgs; [
    cursor-clip
  ];
}

{pkgs, ...}: {
  services.copyq = {
    enable = true;
    package = pkgs.copyq;
    systemdTarget = "graphical-session.target";
    forceXWayland = false;
  };
}

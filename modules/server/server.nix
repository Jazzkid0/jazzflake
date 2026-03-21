{ lib, ... }:
{
  services.xserver.enable = false;
  xdg.portal.enable = false;
  security.polkit.enable = lib.mkForce false;

  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  nixpkgs.config.allowUnfree = true;
}

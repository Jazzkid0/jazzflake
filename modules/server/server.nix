{lib, ...}: {
  services.xserver.enable = false;
  xdg.portal.enable = false;
  security.polkit.enable = lib.mkForce false;
  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };
}

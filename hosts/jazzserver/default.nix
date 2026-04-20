{lib, ...}: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "jazzserver";
  networking.networkmanager.enable = true;

  services.xserver.enable = false;
  xdg.portal.enable = false;
  security.polkit.enable = lib.mkForce false;
  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };

  # DO NOT CHANGE --------------
  system.stateVersion = "24.05";
}

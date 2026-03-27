{...}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/server/server.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "jazzserver";
  networking.networkmanager.enable = true;

  # DO NOT CHANGE --------------
  system.stateVersion = "24.05";
}

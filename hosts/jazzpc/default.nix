{...}: {
  imports = [
    ./hardware-configuration.nix
    ./hardware/mounts.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "jazzpc";
    networkmanager.enable = true;
    interfaces."enp8s0".wakeOnLan.enable = true;
  };

  services.tailscale = {
    useRoutingFeatures = "both";
  };


  system.stateVersion = "25.05";
}

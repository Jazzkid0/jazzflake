{...}: {
  imports = [
    ./hardware-configuration.nix
    ./hardware/mounts.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "jazzpc";
  networking.networkmanager.enable = true;

  services.tailscale = {
    useRoutingFeatures = "both";
  };

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.05";
}

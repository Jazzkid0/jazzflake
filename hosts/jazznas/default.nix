{...}: {
  imports = [
    ./hardware-configuration.nix
    ./hardware/mounts.nix
    ./hardware/disks.nix
  ];

  services.tailscale = {
    useRoutingFeatures = "both";
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "jazznas";
  networking.networkmanager.enable = true;

  users.users.jazzkid.extraGroups = ["media"];

  users.groups.media = {};

  system.stateVersion = "24.11";
}

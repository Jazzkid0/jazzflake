{inputs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./hardware/mounts.nix
    ./hardware/disks.nix

    ../../modules/server/server.nix
    ../../modules/services/samba.nix
    ../../modules/services/silverbullet.nix
    ../../modules/services/attic.nix
    ../../modules/services/cache-builder.nix

    inputs.nixarr.nixosModules.default
    ../../modules/services/nixarr.nix
    ../../modules/services/transmission.nix
    ../../modules/services/jellyfin.nix
    ../../modules/services/prowlarr.nix
    ../../modules/services/radarr.nix
    ../../modules/services/sonarr.nix
    ../../modules/services/lidarr.nix
    ../../modules/services/readarr.nix
    ../../modules/services/bazarr.nix
    ../../modules/services/jellyseerr.nix
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

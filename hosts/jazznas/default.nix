{ config, lib, pkgs, agenix, nixarr, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./hardware/mounts.nix
    ./hardware/disks.nix
    ../../modules/server/server.nix
    ../../modules/services/samba.nix
    ../../modules/services/nixarr.nix
    ../../modules/services/nginx.nix
    ../../modules/services/transmission.nix
    ../../modules/services/qbittorrent.nix
    ../../modules/services/jellyfin.nix
    ../../modules/services/prowlarr.nix
    ../../modules/services/radarr.nix
    ../../modules/services/sonarr.nix
    ../../modules/services/lidarr.nix
    ../../modules/services/readarr.nix
    ../../modules/services/bazarr.nix
    ../../modules/services/jellyseerr.nix
  ];

  # Tailscale - host-specific
  services.tailscale = {
    useRoutingFeatures = "both";
  };

  # Boot configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "jazznas";
  networking.networkmanager.enable = true;

  # Nix settings
  nix.settings.trusted-users = [ "jazzkid" ];

  # User configuration (reduced SSH keys per security review)
  users.users.jazzkid = {
    isNormalUser = true;
    description = "jazzkid";
    extraGroups = [ "networkmanager" "wheel" "media" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFHJpS4qhtDcfcjD0cD0PmnWxay53Y5Xlf0mPOcSdtkL jazzkid@jazzserver"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAvWLv+pEt4tnil5IsMrh/BVqRZLbsuOZZ9MycuH8K6n jazzpc"
    ];
  };

  users.groups.media = {};

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFHJpS4qhtDcfcjD0cD0PmnWxay53Y5Xlf0mPOcSdtkL jazzkid@jazzserver"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAvWLv+pEt4tnil5IsMrh/BVqRZLbsuOZZ9MycuH8K6n jazzpc"
  ];

  # System state (DO NOT EDIT)
  system.stateVersion = "24.11";
}

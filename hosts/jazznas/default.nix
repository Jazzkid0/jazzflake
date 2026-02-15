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

  age.identityPaths = [ "/home/jazzkid/.ssh/id_ed25519" ];

  services.tailscale = {
    useRoutingFeatures = "both";
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "jazznas";
  networking.networkmanager.enable = true;

  nix.settings.trusted-users = [ "jazzkid" ];

  users.users.jazzkid = {
    isNormalUser = true;
    description = "jazzkid";
    extraGroups = [ "networkmanager" "wheel" "media" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFHJpS4qhtDcfcjD0cD0PmnWxay53Y5Xlf0mPOcSdtkL jazzkid@jazzserver" # old
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAvWLv+pEt4tnil5IsMrh/BVqRZLbsuOZZ9MycuH8K6n jazzpc" # old
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOXr41H8R6YjEFGilGFw3k+KmuPyDaOofxctpQMmY18f jazzkid@jazzsl"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEQVZnbcapMI2cVH7/t7WYCcxDbVyQQYIWW4Q51K5CIO jazzkid@jazzserver"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIbpMhMLZqxJXZxKF8PsNtjV69h2HbRwA4HFRAURqjB4 jazzkid@jazznas"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII7Ri38NEb1cN4BA6xQzsqpGrG1VaiRjZxS+D21UV1RA jazzkid@jazzphone"
    ];
  };

  users.groups.media = {};

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFHJpS4qhtDcfcjD0cD0PmnWxay53Y5Xlf0mPOcSdtkL jazzkid@jazzserver" # old
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAvWLv+pEt4tnil5IsMrh/BVqRZLbsuOZZ9MycuH8K6n jazzpc" # old
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOXr41H8R6YjEFGilGFw3k+KmuPyDaOofxctpQMmY18f jazzkid@jazzsl"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEQVZnbcapMI2cVH7/t7WYCcxDbVyQQYIWW4Q51K5CIO jazzkid@jazzserver"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIbpMhMLZqxJXZxKF8PsNtjV69h2HbRwA4HFRAURqjB4 jazzkid@jazznas"
  ];

  system.stateVersion = "24.11";
}

{
  config,
  inputs,
  lib,
  user,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./hardware/mounts.nix
    ./hardware/disks.nix

    ../../modules/services/samba.nix
    ../../modules/services/silverbullet.nix
    ../../modules/services/attic.nix
    ../../modules/services/cache-builder.nix
    ../../modules/services/git-remote.nix
    ../../modules/services/landing-page.nix

    # TODO: abandon nixarr and configure manually
    inputs.nixarr.nixosModules.default
    ../../modules/services/nixarr.nix
    ../../modules/services/transmission.nix
    ../../modules/services/jellyfin.nix
    ../../modules/services/prowlarr.nix
    ../../modules/services/radarr.nix
    ../../modules/services/sonarr.nix
    ../../modules/services/lidarr.nix
    # ../../modules/services/readarr.nix # TODO: Replace with shelfmark
    ../../modules/services/bazarr.nix
    ../../modules/services/storage-management.nix
    ../../modules/services/jellyseerr.nix
    ../../modules/services/prometheus.nix
  ];

  services.tailscale = {
    useRoutingFeatures = "both";
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "jazznas";
  networking.networkmanager.enable = true;

  users.users.${user}.extraGroups = ["media"];

  users.groups.media = {};

  services.xserver.enable = false;
  xdg.portal.enable = false;
  security.polkit.enable = lib.mkForce false;
  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };

  programs.ssh.extraConfig = ''
    Host github-jazzflake
      HostName github.com
      User git
      IdentityFile ${config.age.secrets.github-deploy-key.path}
      IdentitiesOnly yes
  '';

  system.stateVersion = "24.11";
}

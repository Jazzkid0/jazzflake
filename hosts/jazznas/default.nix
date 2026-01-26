{ config, lib, pkgs, agenix, nixarr, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
      ./hardware/mounts.nix
      ./hardware/disks.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernel.sysctl."net.ipv4.ip_forward" = true;
  boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = true;

  networking.hostName = "jazznas";
  networking.networkmanager.enable = true;

  services.tailscale.useRoutingFeatures = "both";

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

  programs.mosh.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = ["jazzkid"];

  time.timeZone = "Europe/London";

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = [
    agenix.packages.${pkgs.system}.default
  ];

  system.stateVersion = "24.11"; # DO NOT EDIT
}

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

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = ["jazzkid"];

  time.timeZone = "Europe/London";

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "24.11"; # DO NOT EDIT
}

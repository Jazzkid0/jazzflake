{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader = {
    grub = {
      enable = true;
      efiSupport = true;
      devices = ["nodev"];
    };
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
  };

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;

  networking.hostName = "jazznode";
  networking.firewall.allowedTCPPorts = [22];

  services.tailscale.useRoutingFeatures = "both";

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  system.stateVersion = "24.05";
}

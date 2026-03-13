{ pkgs, ... }:
{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  age.identityPaths = [ "/home/jazzkid/.ssh/id_ed25519" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "jazzpc";
  networking.networkmanager.enable = true;

  services.tailscale = {
    useRoutingFeatures = "both";
  };

  users.users.jazzkid = {
    isNormalUser = true;
    description = "jazzkid";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOXr41H8R6YjEFGilGFw3k+KmuPyDaOofxctpQMmY18f jazzkid@jazzsl"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEQVZgbcapMI2cVH7/t7WYCcxDbVyQQYIWW4Q51K5CIO jazzkid@jazzserver"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIbpMhMLZqxJXZxKF8PsNtjV69h2HbRwA4HFRAURqjB4 jazzkid@jazznas"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII7Ri38NEb1cN4BA6xQzsqpGrG1VaiRjZxS+D21UV1RA jazzkid@jazzphone"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPCRD3bZT/rqSSmteMz58X1di54tbHiOQTx3G8wXbezQ jazzkid@jazztab"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDIN3rt+uOSH4HrmG/LiNb3r7rCBX3j5PGoy3MROYOjZ jazzkid@jazzpc"
    ];
  };

  nix.settings.trusted-users = ["jazzkid"];
  nixpkgs.config.allowUnfree = true;

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOXr41H8R6YjEFGilGFw3k+KmuPyDaOofxctpQMmY18f jazzkid@jazzsl"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEQVZgbcapMI2cVH7/t7WYCcxDbVyQQYIWW4Q51K5CIO jazzkid@jazzserver"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIbpMhMLZqxJXZxKF8PsNtjV69h2HbRwA4HFRAURqjB4 jazzkid@jazznas"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDIN3rt+uOSH4HrmG/LiNb3r7rCBX3j5PGoy3MROYOjZ jazzkid@jazzpc"
  ];

  system.stateVersion = "25.05";
}

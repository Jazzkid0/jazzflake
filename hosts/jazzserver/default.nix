{ pkgs, ... }:
{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "jazzserver";
  networking.networkmanager.enable = true;

  users.users.jazzkid = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOXr41H8R6YjEFGilGFw3k+KmuPyDaOofxctpQMmY18f jazzkid@jazzsl"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEQVZnbcapMI2cVH7/t7WYCcxDbVyQQYIWW4Q51K5CIO jazzkid@jazzserver"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIbpMhMLZqxJXZxKF8PsNtjV69h2HbRwA4HFRAURqjB4 jazzkid@jazznas"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII7Ri38NEb1cN4BA6xQzsqpGrG1VaiRjZxS+D21UV1RA jazzkid@jazzphone"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPCRD3bZT/rqSSmteMz58X1di54tbHiOQTx3G8wXbezQ jazzkid@jazztab"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDIN3rt+uOSH4HrmG/LiNb3r7rCBX3j5PGoy3MROYOjZ jazzkid@jazzpc"
    ];
  };

  nix.settings.trusted-users = ["jazzkid"];
  services.nginx.virtualHosts."dev.jazzkid.xyz" = {
    # TODO: Fix certs
    # forceSSL = true;
    # enableACME = true;
    # acmeRoot = null;
    locations."/" = {
      proxyPass = "http://127.0.0.1:8080";
      proxyWebsockets = true;
    };
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOXr41H8R6YjEFGilGFw3k+KmuPyDaOofxctpQMmY18f jazzkid@jazzsl"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEQVZnbcapMI2cVH7/t7WYCcxDbVyQQYIWW4Q51K5CIO jazzkid@jazzserver"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIbpMhMLZqxJXZxKF8PsNtjV69h2HbRwA4HFRAURqjB4 jazzkid@jazznas"
  ];


  # DO NOT CHANGE --------------
  system.stateVersion = "24.05";
}

{ pkgs, ... }:
{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true; # Use the systemd-boot EFI boot loader.
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "jazzserver";
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  users.users.jazzkid = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    openssh.authorizedKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAvWLv+pEt4tnil5IsMrh/BVqRZLbsuOZZ9MycuH8K6n jazzpc"
    ];
  };

  nix.settings.trusted-users = ["jazzkid"];
  services.nginx.virtualHosts."dev.jazzkid.xyz" = {
    # forceSSL = true;
    # enableACME = true;
    locations."/".proxyPass = "http://localhost:8080";
  };

  programs.mosh.enable = true;

  users.users.root.openssh.authorizedKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAvWLv+pEt4tnil5IsMrh/BVqRZLbsuOZZ9MycuH8K6n jazzpc"
  ];


  # DO NOT CHANGE --------------
  system.stateVersion = "24.05";
}

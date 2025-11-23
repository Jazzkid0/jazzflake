{ pkgs, lib, ... }:
{
  networking.firewall.allowedTCPPorts = [
    22
    80
  ];

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  programs.ssh.startAgent = true;
}

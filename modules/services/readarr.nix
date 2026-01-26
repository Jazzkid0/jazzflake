{ config, pkgs, lib, nixarr, ... }:

{
  users.users.readarr = {
    extraGroups = [ "media" ];
  };

  users.groups.readarr = {};

  nixarr.readarr = {
    enable = true;
    openFirewall = true;
  };

  services.nginx.virtualHosts."readarr.jazzkid.xyz" = {
    forceSSL = true;
    enableACME = true;
    acmeRoot = null;
    locations."/" = {
      proxyPass = "http://127.0.0.1:8787";
    };
  };
}

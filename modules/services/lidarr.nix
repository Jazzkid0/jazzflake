{ config, pkgs, lib, nixarr, ... }:

{
  users.users.lidarr = {
    extraGroups = [ "media" ];
  };

  users.groups.lidarr = {};

  nixarr.lidarr = {
    enable = true;
    openFirewall = true;
  };

  services.nginx.virtualHosts."lidarr.jazzkid.xyz" = {
    forceSSL = true;
    enableACME = true;
    acmeRoot = null;
    locations."/" = {
      proxyPass = "http://127.0.0.1:8686";
    };
  };
}

{ config, pkgs, lib, nixarr, ... }:

{
  users.users.bazarr = {
    extraGroups = [ "media" ];
  };

  users.groups.bazarr = {};

  nixarr.bazarr = {
    enable = true;
    openFirewall = true;
  };

  services.nginx.virtualHosts."bazarr.jazzkid.xyz" = {
    forceSSL = true;
    enableACME = true;
    acmeRoot = null;
    locations."/" = {
      proxyPass = "http://127.0.0.1:6767";
    };
  };
}

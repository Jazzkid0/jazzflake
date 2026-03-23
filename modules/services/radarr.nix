{
  config,
  pkgs,
  lib,
  nixarr,
  ...
}: {
  users.users.radarr = {
    extraGroups = ["media"];
  };

  users.groups.radarr = {};

  nixarr.radarr = {
    enable = true;
    openFirewall = true;
  };

  services.nginx.virtualHosts."radarr.jazzkid.xyz" = {
    forceSSL = true;
    enableACME = true;
    acmeRoot = null;
    locations."/" = {
      proxyPass = "http://127.0.0.1:7878";
    };
  };
}

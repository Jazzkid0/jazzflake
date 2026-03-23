{
  config,
  pkgs,
  lib,
  nixarr,
  ...
}: {
  users.users.prowlarr = {
    extraGroups = ["media"];
  };

  users.groups.prowlarr = {};

  nixarr.prowlarr = {
    enable = true;
    openFirewall = true;
  };

  services.nginx.virtualHosts."prowlarr.jazzkid.xyz" = {
    forceSSL = true;
    enableACME = true;
    acmeRoot = null;
    locations."/" = {
      proxyPass = "http://127.0.0.1:9696";
    };
  };
}

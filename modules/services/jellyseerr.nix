{
  config,
  pkgs,
  lib,
  nixarr,
  ...
}: {
  users.users.seerr = {
    extraGroups = ["media"];
  };

  nixarr.seerr = {
    enable = true;
    openFirewall = true;
  };

  services.nginx.virtualHosts."jellyseerr.jazzkid.xyz" = {
    forceSSL = true;
    enableACME = true;
    acmeRoot = null;
    locations."/" = {
      proxyPass = "http://127.0.0.1:5055";
    };
  };
}

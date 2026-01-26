{ config, pkgs, lib, nixarr, ... }:

{
  users.users.jellyfin = {
    isSystemUser = true;
    group = "media";
    home = "/var/lib/jellyfin";
    extraGroups = [ "jellyfin" ];
    createHome = true;
  };

  users.groups.jellyfin = {};

  nixarr.jellyfin = {
    enable = true;
    openFirewall = true;
    expose.https = {
      enable = true;
      acmeMail = "jonathan@jknightdev.co.uk";
      domainName = "jellyfin.jazzkid.xyz";
    };
  };

  services.nginx.virtualHosts."jellyfin.jazzkid.xyz" = {
    forceSSL = true;
    enableACME = true;
    acmeRoot = null;
    locations."/" = {
      proxyPass = "http://127.0.0.1:8096";
      extraConfig = ''
        proxy_set_header X-Transmission-Session-Id $http_x_transmission_session_id;
      '';
    };
  };
}

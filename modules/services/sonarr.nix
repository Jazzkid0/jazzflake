{...}: {
  users.users.sonarr = {
    extraGroups = ["media"];
  };

  users.groups.sonarr = {};

  nixarr.sonarr = {
    enable = true;
    openFirewall = true;
  };

  services.nginx.virtualHosts."sonarr.jazzkid.xyz" = {
    forceSSL = true;
    enableACME = true;
    acmeRoot = null;
    locations."/" = {
      proxyPass = "http://127.0.0.1:8989";
    };
  };
}

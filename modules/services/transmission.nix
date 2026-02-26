{ config, pkgs, lib, nixarr, ... }:

{
  users.users.transmission = {
    isSystemUser = true;
    group = "media";
    home = lib.mkForce "/var/lib/transmission";
    extraGroups = [ "media" "smb" ];
    createHome = true;
  };

  age.secrets.transmission_credentialsFile = {
    file = ../../secrets/transmission_credentialsFile.age;
    owner = "transmission";
    group = "media";
    mode = "0400";
  };

  nixarr.transmission = {
    enable = true;
    openFirewall = true;
    credentialsFile = config.age.secrets.transmission_credentialsFile.path;
    extraAllowedIps = [ "192.168.1.*" "192.168.1.99" "100.64.0.0/10" ];
    extraSettings = {
      rpc-username = "jazzkid";
      rpc-whitelist-enabled = false;
      rpc-host-whitelist-enabled = true;
      rpc-host-whitelist = "transmission.jazzkid.xyz,localhost,127.0.0.1";
      download-dir = "/srv/media/media-lib/downloads";
      incomplete-dir = "/srv/media/media-lib/downloads/incomplete";
    };
    messageLevel = "debug";
  };

  services.nginx.virtualHosts."transmission.jazzkid.xyz" = {
    forceSSL = true;
    enableACME = true;
    acmeRoot = null;
    locations."/" = {
      proxyPass = "http://127.0.0.1:9091";
      extraConfig = ''
        proxy_set_header X-Transmission-Session-Id $http_x_transmission_session_id;
      '';
    };
  };

  # Tailscale access for torrent peers
  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 50000 ];
  networking.firewall.interfaces.tailscale0.allowedUDPPorts = [ 50000 ];
}

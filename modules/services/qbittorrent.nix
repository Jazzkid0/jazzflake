{ config, pkgs, ... }:

{
  environment.systemPackages = [ pkgs.qbittorrent-nox ];

  systemd.services.qbittorrent-nox = {
    description = "qbittorrent-nox headless daemon";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.qbittorrent-nox}/bin/qbittorrent-nox --confirm-legal-notice --webui-port=8080 --profile=/var/lib/qbittorrent/.config";
      Restart = "always";
      User = "qbittorrent";
      Environment = "HOME=/var/lib/qbittorrent";
    };

    preStart = ''
      mkdir -p /var/lib/qbittorrent/.config/qBittorrent/config
      cp ${config.age.secrets.qbittorrent_conf.path} /var/lib/qbittorrent/.config/qBittorrent/config/qBittorrent.conf
      chown qbittorrent:media /var/lib/qbittorrent/.config/qBittorrent/config/qBittorrent.conf
      chmod 400 /var/lib/qbittorrent/.config/qBittorrent/config/qBittorrent.conf
    '';

  };

  age.secrets.qbittorrent_conf = {
    file = ../../secrets/qbittorrent_conf.age;
    owner = "qbittorrent";
    group = "media";
    mode = "0400";
  };

  users.users.qbittorrent = {
    isSystemUser = true;
    group = "media";
    home = "/var/lib/qbittorrent";
    createHome = true;
  };


  # LAN access for WebUI
  networking.firewall.allowedTCPPorts = [ 8080 ];

  # Tailscale access for WebUI and torrent peers
  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 8080 51413 ];
  networking.firewall.interfaces.tailscale0.allowedUDPPorts = [ 51413 ];

  services.nginx.virtualHosts."qbittorrent.jazzkid.xyz" = {
    forceSSL = true;
    enableACME = true;
    acmeRoot = null;
    locations."/" = {
      proxyPass = "http://127.0.0.1:8080";
    };
  };

  # environment.persistence."var/lib".directories = [ "qbittorrent" ]; TODO: Set up persistence between reboots via `impermanence`
}

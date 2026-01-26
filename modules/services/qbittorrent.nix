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
      cp /etc/nixos/qbittorrent/qBittorrent.conf /var/lib/qbittorrent/.config/qBittorrent/config/qBittorrent.conf
      chown -R qbittorrent:media /var/lib/qbittorrent/.config/qBittorrent/config
      chmod 644 /var/lib/qbittorrent/.config/qBittorrent/config/qBittorrent.conf
    '';
  };

  environment.etc."nixos/qbittorrent/qBittorrent.conf".text = ''
    [Preferences]
    WebUI\Username=jazzkid
    WebUI\Password_PBKDF2=@ByteArray(wXbS4Ld0uoHO2NjYfwPYdQ==:Fc1CSYqQw7lkGqUmDkNDXKQ1p1XDAnp7XJXAtzK3srH6J0msvTTaukUjeBXlRggdH/Bhg2sVhxuOnmZL2HajDQ==)
    WebUI\Port=8080
  '';

  users.users.qbittorrent = {
    isSystemUser = true;
    group = "media";
    home = "/var/lib/qbittorrent";
    createHome = true;
  };


  networking.firewall.allowedTCPPorts = [ 8080 ];

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

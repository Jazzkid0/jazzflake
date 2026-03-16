{ config, pkgs, ... }:

{
  services.silverbullet = {
    enable = true;
    spaceDir = "/home/jazzkid/notes";
    listenPort = 8073;
    listenAddress = "127.0.0.1";
    envFile = config.age.secrets.silverbullet_credentialsFile.path;
    user = "jazzkid";
    group = "media";
  };
  
  age.secrets.silverbullet_credentialsFile = {
    file = ../../secrets/silverbullet_credentialsFile.age;
    owner = "jazzkid";
    group = "media";
    mode = "0400";
  };

  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 8073 ];

  services.nginx.virtualHosts."notes.jazzkid.xyz" = {
    forceSSL = true;
    enableACME = true;
    acmeRoot = null;
    locations."/" = {
      proxyPass = "http://127.0.0.1:8073";
      proxyWebsockets = true;
    };
  };

  systemd.services.silverbullet-sync = {
    description = "Silverbullet git sync";

    serviceConfig = {
      Type = "oneshot";
      User = "jazzkid";
      WorkingDirectory = "/home/jazzkid/notes";
    };

    path = (with pkgs; [
      jujutsu
      git
      openssh
    ]);

    script = ''
      set -euo pipefail

      if ! [ -z "$(jj diff --summary)" ]; then
        jj bookmark move main
        jj commit -m"auto: sync"
        jj git push --bookmark main;
      else
        echo "No changes detected."
      fi
    '';
  };

  systemd.timers.silverbullet-sync = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "5min";
      OnUnitActiveSec = "60s";
      Unit = "silverbullet-sync.service";
    };
  };
}

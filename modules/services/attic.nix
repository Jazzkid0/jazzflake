{
  config,
  pkgs,
  lib,
  ...
}: {
  users.users.atticd = {
    isSystemUser = true;
    group = "atticd";
    home = "/var/lib/atticd";
    createHome = true;
  };

  users.groups.atticd = {};

  age.secrets.attic-environment-file = {
    file = ../../secrets/attic-environment-file.age;
    owner = "atticd";
    group = "atticd";
  };

  systemd.tmpfiles.rules = [
    "d /data/nix-cache 0755 atticd atticd -"
    "f /var/lib/private/atticd/db.sqlite3 0644 atticd atticd -"
  ];

  services.atticd = {
    enable = true;
    environmentFile = config.age.secrets.attic-environment-file.path;

    settings = {
      listen = "[::1]:6463";
      database.url = "sqlite:////var/lib/private/atticd/db.sqlite3";

      jwt = {};

      "allowed-hosts" = [ "cachix.jazzkid.xyz" ];
      "api-endpoint" = "https://cachix.jazzkid.xyz/";

      storage = {
        type = "local";
        path = "/data/nix-cache";
      };

      chunking = {
        nar-size-threshold = 65536;
        min-size = 16384;
        avg-size = 65536;
        max-size = 262144;
      };

      garbage-collection = {
        interval = "12 hours";
        default-retention-period = "6 months";
      };

      compression = {
        type = "zstd";
      };
    };
  };

  systemd.services.atticd.serviceConfig = {
    DynamicUser = lib.mkForce false;
    ReadWritePaths = [ "/data/nix-cache" ];
    RequiresMountsFor = [ "/data" ];
  };

  systemd.services.attic-init = {
    after = [ "atticd.service" ];
    requires = [ "atticd.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    path = [ pkgs.curl config.services.atticd.package ];
    script = ''
      until curl -s http://[::1]:6463/api/v1/server-info > /dev/null; do sleep 1; done
      if ! atticd-atticadm cache info main 2>/dev/null; then
        atticd-atticadm cache create main --public --priority 39
      fi
    '';
  };

  services.nginx.virtualHosts."cachix.jazzkid.xyz" = {
    enableACME = true;
    forceSSL = true;
    acmeRoot = null;
    locations."/" = {
      proxyPass = "http://[::1]:6463";
      extraConfig = ''
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        client_max_body_size 8G;
        proxy_request_buffering off;
      '';
    };
  };
}

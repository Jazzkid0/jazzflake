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

  age.secrets.attic-signing-key = {
    file = ../../secrets/attic-signing-key.age;
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

      storage = {
        type = "local";
        path = "/data/nix-cache";
      };

      # TODO: Tune these later
      chunking = {
        nar-size-threshold = 65536; # chunk @ >64KiB
        min-size = 16384;
        avg-size = 65536;
        max-size = 262144;
      };

      garbage-collection = {
        interval = "12 hours";
        default-retention-period = "6 months";
      };
    };
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

        # avoid choking nginx with large NARs
        client_max_body_size 8G;
        proxy_request_buffering off;
      '';
    };
  };

  nix.settings = {
    secret-key-files = [config.age.secrets.attic-signing-key.path];
  };
}

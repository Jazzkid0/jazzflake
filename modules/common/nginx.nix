{
  config,
  domain,
  ...
}: {
  users.groups.nginx = {};
  users.users.nginx = {
    isSystemUser = true;
    group = "nginx";
  };

  age.secrets.cloudflare_apiTokenFile = {
    file = ../../secrets/cloudflare_apiTokenFile.age;
    owner = "root";
    group = "acme";
    mode = "0440";
  };

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "jonathan@jknightdev.co.uk";
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53,8.8.8.8:53,9.9.9.9:53";
      extraLegoFlags = ["--dns.propagation-wait" "5m0s"];
      credentialFiles = {
        "CF_DNS_API_TOKEN_FILE" = config.age.secrets.cloudflare_apiTokenFile.path;
        "CF_ZONE_API_TOKEN_FILE" = config.age.secrets.cloudflare_apiTokenFile.path;
      };
      group = "acme";
    };
    certs.${domain} = {
      enableDebugLogs = true;
    };
  };

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts.${domain} = {
      forceSSL = true;
      enableACME = true;
      acmeRoot = null;
      locations."/" = {
        return = "200 'Welcome to ${config.networking.hostName}'";
        extraConfig = "add_header Content-Type text/plain;";
      };
    };
  };

  networking.firewall.allowedTCPPorts = [80 443];
  networking.firewall.allowedUDPPorts = [443];
}

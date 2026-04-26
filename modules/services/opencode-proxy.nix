_: {
  services.nginx.virtualHosts."opencode.pc.jazzkid.xyz" = {
    forceSSL = true;
    enableACME = true;
    acmeRoot = null;
    locations."/" = {
      proxyPass = "http://127.0.0.1:32123";
      proxyWebsockets = true;
      extraConfig = ''
        allow 192.168.1.0/24;
        allow 100.64.0.0/10;
        allow fd7a:115c:a1e0::/48;
        allow 127.0.0.1;
        allow ::1;
        deny all;
      '';
    };
  };
}

_: let
  hosts = ["jazznas" "jazzpc" "jazzserver"];
in {
  services.prometheus = {
    enable = true;
    port = 9090;
    listenAddress = "0.0.0.0";
    retentionTime = "15d";
    webExternalUrl = "http://jazznas:9090";

    scrapeConfigs = [
      {
        job_name = "node";
        scrape_interval = "30s";
        static_configs = [
          {
            targets = map (h: "${h}:9100") hosts;
          }
        ];
      }
      {
        job_name = "nginx";
        scrape_interval = "30s";
        static_configs = [
          {
            targets = map (h: "${h}:9113") hosts;
          }
        ];
      }
      {
        job_name = "prometheus";
        scrape_interval = "30s";
        static_configs = [
          {
            targets = ["localhost:9090"];
          }
        ];
      }
    ];
  };

  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [9090];
}

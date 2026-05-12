_: {
  services.prometheus.exporters.node = {
    enable = true;
    port = 9100;
    openFirewall = false;
    disabledCollectors = [
      "hwmon"
      "qdisc"
      "sysctl"
    ];
  };

  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [9100];
}

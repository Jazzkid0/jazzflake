{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./hardware/mounts.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "jazzpc";
    networkmanager.enable = true;
    interfaces."enp8s0".wakeOnLan.enable = true;
  };

  services.tailscale = {
    useRoutingFeatures = "both";
  };

  # wake-on-lan fix
  systemd.services.wol-persist = {
    description = "Persist Wake-on-LAN setting through shutdown";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.ethtool}/bin/ethtool -s enp8s0 wol g";
      ExecStop = "${pkgs.ethtool}/bin/ethtool -s enp8s0 wol g";
    };
  };

  system.stateVersion = "25.05";
}

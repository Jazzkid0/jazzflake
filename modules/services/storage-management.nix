{
  config,
  pkgs,
  lib,
  ...
}: {
  # ── jdupes hardlink dedup ────────────────────────────────────────

  environment.systemPackages = [pkgs.jdupes];

  systemd.services.jdupes-dedup = {
    description = "Hardlink duplicate files under /srv/";
    serviceConfig = {
      Type = "oneshot";
      Nice = 19;
      IOSchedulingClass = "idle";
      CPUQuota = "25%";
      ExecStart = "${pkgs.jdupes}/bin/jdupes --recurse --linkhard /srv/";
    };
  };

  systemd.timers.jdupes-dedup = {
    description = "Nightly hardlink dedup timer";
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "*-*-* 03:00:00";
      Persistent = true;
      RandomizedDelaySec = "10min";
    };
  };

  # ── beesd btrfs block-level dedup ────────────────────────────────

  services.beesd.filesystems."srv-media" = {
    spec = "/srv/media";
    hashTableSizeMB = 256;
    verbosity = "warning";
  };
}

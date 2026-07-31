{
  config,
  pkgs,
  ...
}: let
  repoPath = "/home/jazzkid/dev/nix/jazzflake";
in {
  systemd.services.nix-cache-build = {
    description = "Build all flake outputs and push to attic cache";
    wants = [ "atticd.service" ];
    after = [ "atticd.service" ];

    serviceConfig = {
      Type = "oneshot";
      User = "jazzkid";
      WorkingDirectory = repoPath;
      Nice = 10;
      IOSchedulingClass = "idle";
      CPUQuota = "80%";
      MemoryHigh = "6G";
      MemoryMax = "8G";
    };

    environment.XDG_CONFIG_HOME = "/etc";

    path = with pkgs; [
      nix
      attic-client
    ];

    script = ''
      set -euo pipefail
      FAILED=0

      HOSTS=$(nix eval --json .#nixosConfigurations --apply 'x: builtins.attrNames x')
      BUILT_PATHS=""
      for host in $HOSTS; do
        echo "Building nixosConfiguration: $host"
        if out=$(nix build --print-out-paths ".#nixosConfigurations.$host.config.system.build.toplevel" 2>&1 | tee /dev/stderr); then
          BUILT_PATHS="$BUILT_PATHS $out"
        else
          echo "FAILED to build $host"
          FAILED=1
        fi
      done

      PACKAGES=$(nix eval --json .#packages.x86_64-linux --apply 'x: builtins.attrNames x')
      for pkg in $PACKAGES; do
        echo "Building package: $pkg"
        if out=$(nix build --print-out-paths ".#packages.x86_64-linux.$pkg" 2>&1 | tee /dev/stderr); then
          BUILT_PATHS="$BUILT_PATHS $out"
        else
          echo "FAILED to build $pkg"
          FAILED=1
        fi
      done

      if [ -n "$BUILT_PATHS" ]; then
        echo "$BUILT_PATHS" | xargs attic push main
      fi

      if [ "$FAILED" -eq 0 ]; then
        echo "Build complete — all targets succeeded"
      else
        echo "Build complete — some targets failed, see log above"
      fi
    '';
  };

  systemd.timers.nix-cache-build = {
    description = "Daily attic cache build timer";
    wantedBy = [ "timers.target" ];

    timerConfig = {
      OnCalendar = "daily";
      RandomizedDelaySec = "1h";
      Persistent = true;
    };
  };
}

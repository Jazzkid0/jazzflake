{ config, pkgs, ... }:

let
  repoUrl = "github_jazzkid:Jazzkid0/package-attic.git";
  repoPath = "/var/lib/package-attic";
  gitName = "jazzkid";
  gitEmail = "jazzkid@jazzkid.xyz";
in
{
  age.secrets.attic-token = {
    file = ../../secrets/attic-token.age;
    owner = "jazzkid";
    group = "users";
  };

  systemd.services.attic-push = {
    description = "Build and push packages to the attic cache";
    wants = [ "network-online.target" "atticd.service" ];
    after = [ "network-online.target" "atticd.service" ];

    serviceConfig = {
      Type = "oneshot";
      User = "jazzkid";
      EnvironmentFile = config.age.secrets.attic-token.path;
      Environment = [
        "GIT_SSH_COMMAND=${pkgs.openssh}/bin/ssh -o StrictHostKeyChecking=accept-new"
      ];
    };

    script = ''
      set -euo pipefail

      export HOME="/home/jazzkid"
      export GIT_AUTHOR_NAME="${gitName}"
      export GIT_AUTHOR_EMAIL="${gitEmail}"
      export GIT_COMMITTER_NAME="${gitName}"
      export GIT_COMMITTER_EMAIL="${gitEmail}"

      if [ ! -d "${repoPath}/.git" ];
        echo "Cloning packages repo..."
        ${pkgs.git}/bin/git clone ${repoUrl} ${repoPath}
      fi

      cd ${repoPath}

      // reset to main
      ${pkgs.git}/bin/git fetch origin
      ${pkgs.git}/bin/git checkout -B built origin/main

      // update packages and build
      ${pkgs.nix}/bin/nix flake update

      PACKAGES=$(${pkgs.nix}/bin/nix build \
        --no-link \
        --print-out-paths \
        $(${pkgs.nix}/bin/nix eval --json .#packages.x86_64-linux \
          | ${pkgs.jq}/bin/jq -r 'keys[] | ".#packages.x86_64-linux.\(.)"' \
        )
      )

      echo "$PACKAGES" | xargs ${pkgs.attic-client}/bin/attic push main

      // commit and push
      ${pkgs.git}/bin/git add flake.lock
      ${pkgs.git}/bin/git commit -m"auto: update flake.lock $(date -u +%Y-%m-%d)"
      ${pkgs.git}/bin/git push --force-with-lease origin built

      echo "packages updated successfully"

    '';
  };

  # TODO: enable after testing
  # systemd.timers.attic-push = {
  #   description = "Daily Attic cache push timer";
  #   wantedBy = [ "timers.target" ];
  #
  #   timerConfig = {
  #     OnCalendar = "daily";
  #     RandomizedDelaySec = "1h";
  #     Persistent = true;
  #   };
  # };
}

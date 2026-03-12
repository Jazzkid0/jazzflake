{ config, pkgs, ... }:

let
  repoUrl = "github_jazzkid:Jazzkid0/package-attic.git";
  repoPath = "/var/lib/package-attic";
  gitName = "jazzkid";
  gitEmail = "jazzkid@jazzkid.xyz";
  home = "/home/jazzkid";
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

      export HOME="${home}"
      export GIT_AUTHOR_NAME="${gitName}"
      export GIT_AUTHOR_EMAIL="${gitEmail}"
      export GIT_COMMITTER_NAME="${gitName}"
      export GIT_COMMITTER_EMAIL="${gitEmail}"

      if [ ! -d "${repoPath}/.git" ]; then
        echo "Cloning packages repo..."
        ${pkgs.jujutsu}/bin/jj git clone ${repoUrl} ${repoPath};
      fi

      cd ${repoPath}

      // reset to main
      ${pkgs.jujutsu}/bin/jj git fetch origin
      ${pkgs.git}/bin/git checkout -B built origin/main

      // update packages
      ${pkgs.nix}/bin/nix flake update

      // commit for clean state
      ${pkgs.jujutsu}/bin/jj commit -m"auto: flake update $(date -u +%Y-%m-%d)"

      OUTPUTS=$(${pkgs.nix}/bin/nix flake show --json \
        | ${pkgs.jq}/bin/jq -r '".#\(.[][] | keys[])^*"'
      )

      PACKAGES=$(echo "$OUTPUTS" \
        | xargs ${pkgs.nix}/bin/nix build \
          --no-link \
          --print-out-paths \
      )

      echo "$PACKAGES" | xargs ${pkgs.attic-client}/bin/attic push main

      // commit and push
      ${pkgs.jujutsu}/bin/jj commit -m"auto: build packages $(date -u +%Y-%m-%d)"
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

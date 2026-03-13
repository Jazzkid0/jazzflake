{ config, pkgs, ... }:

let
  gitName = "jazzkid";
  gitEmail = "jazzkid@jazzkid.xyz";
  repoUrl = "github_jazzkid:Jazzkid0/package-attic.git";
  repoPath = "/var/lib/package-attic";
in
{
  age.secrets.attic-token = {
    file = ../../secrets/attic-token.age;
    owner = "jazzkid";
    group = "users";
  };

  age.secrets.attic-signing-key = {
    file = ../../secrets/attic-signing-key.age;
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
    };

    script = ''
      set -euo pipefail

      if [ ! -d "${repoPath}/.git" ]; then
        echo "Cloning packages repo..."
        ${pkgs.jujutsu}/bin/jj git clone ${repoUrl} ${repoPath};
      fi

      cd ${repoPath}
      ${pkgs.jujutsu}/bin/jj git fetch --config user.name=${gitName} --config user.email=${gitEmail}
      ${pkgs.jujutsu}/bin/jj new main --config user.name=${gitName} --config user.email=${gitEmail}
      ${pkgs.jujutsu}/bin/jj branch create jazzpkgs --config user.name=${gitName} --config user.email=${gitEmail}

      ${pkgs.nix}/bin/nix flake update
      ${pkgs.jujutsu}/bin/jj commit -m"auto: flake update" --config user.name=${gitName} --config user.email=${gitEmail}

      PACKAGES=$(${pkgs.nix}/bin/nix run .#build-all)

      echo "$PACKAGES" | xargs ${pkgs.nix}/bin/nix store sign --key-file ${config.age.secrets.attic-signing-key.path} --recursive

      echo "$PACKAGES" | xargs ${pkgs.attic-client}/bin/attic push main

      ${pkgs.jujutsu}/bin/jj git push -b jazzpkgs --config user.name=${gitName} --config user.email=${gitEmail}

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

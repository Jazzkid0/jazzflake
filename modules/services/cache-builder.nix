{
  config,
  pkgs,
  ...
}: let
  gitName = "jazzkid";
  gitEmail = "jazzkid@jazzkid.xyz";
  repoUrl = "github_jazzkid:Jazzkid0/package-attic.git";
  repoPath = "/var/lib/package-attic";
in {
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
    wants = ["network-online.target" "atticd.service"];
    after = ["network-online.target" "atticd.service"];

    serviceConfig = {
      Type = "oneshot";
      User = "jazzkid";
      EnvironmentFile = config.age.secrets.attic-token.path;
    };

    path = with pkgs; [
      nix
      openssh
      git
      jujutsu
      attic-client
    ];

    script = ''
      set -euo pipefail

      if [ ! -d "${repoPath}/.git" ]; then
        echo "Cloning packages repo..."
        jj git clone ${repoUrl} ${repoPath}
        cd ${repoPath}
        jj git fetch --config user.name=${gitName} --config user.email=${gitEmail}
        jj new main --config user.name=${gitName} --config user.email=${gitEmail}
        jj bookmark create jazzpkgs --config user.name=${gitName} --config user.email=${gitEmail}
      else
        cd ${repoPath}
        jj git fetch --config user.name=${gitName} --config user.email=${gitEmail}
        jj new main --config user.name=${gitName} --config user.email=${gitEmail}
        jj bookmark set jazzpkgs --config user.name=${gitName} --config user.email=${gitEmail} --allow-backwards
      fi


      nix flake update
      jj commit -m"auto: flake update" --config user.name=${gitName} --config user.email=${gitEmail}

      PACKAGES=$(nix run .#build-all)

      echo "$PACKAGES" | xargs nix store sign --key-file ${config.age.secrets.attic-signing-key.path} --recursive

      echo "$PACKAGES" | xargs attic push main

      jj git push -b jazzpkgs --config user.name=${gitName} --config user.email=${gitEmail}

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

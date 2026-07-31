{
  config,
  lib,
  pkgs,
  sshKeys,
  ...
}: let
  pushHosts = [ "jazznas" "jazzpc" ];
  isPushHost = builtins.elem config.networking.hostName pushHosts;
in {
  users.users.root.openssh.authorizedKeys.keys = with sshKeys; [jazzsl jazzserver jazznas jazzpc];

  nix.settings = {
    extra-substituters = [ "https://cachix.jazzkid.xyz/main" ];
    trusted-substituters = [ "https://cachix.jazzkid.xyz/main" ];
    extra-trusted-public-keys = [ "TODO:paste-key-from-atticd-atticadm-cache-info" ];
  };

  age.secrets.attic-push-token = lib.mkIf isPushHost {
    file = ../../secrets/attic-push-token.age;
    owner = "jazzkid";
    group = "users";
    mode = "0440";
  };

  environment.etc."attic/config.toml" = lib.mkIf isPushHost {
    text = ''
      default-server = "jazznas"
      [servers.jazznas]
      endpoint = "https://cachix.jazzkid.xyz/"
      token-file = "${config.age.secrets.attic-push-token.path}"
    '';
    mode = "0444";
  };

  systemd.services.attic-watch-store = lib.mkIf isPushHost {
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.attic-client}/bin/attic watch-store main";
      Restart = "on-failure";
      RestartSec = 30;
    };
    environment.XDG_CONFIG_HOME = "/etc";
  };
}

let
  sshKeys = import ../modules/common/ssh-keys.nix;
  keys = with sshKeys; [jazzsl jazzserver jazznas jazzpc];
  jazznasKeys = with sshKeys; [jazzsl jazznas];
  pushHostKeys = with sshKeys; [jazzsl jazznas jazzpc];
in {
  "cloudflare_apiTokenFile.age".publicKeys = keys;
  "transmission_credentialsFile.age".publicKeys = keys;
  "silverbullet_credentialsFile.age".publicKeys = keys;
  "qbittorrent_conf.age".publicKeys = keys;
  "attic-environment-file.age".publicKeys = jazznasKeys;
  "attic-push-token.age".publicKeys = pushHostKeys;

  "samba-creds.age".publicKeys = keys;
  "opencode-env.age".publicKeys = keys;
}

let
  sshKeys = import ../modules/common/ssh-keys.nix;
  keys = with sshKeys; [jazzsl jazzserver jazznas jazzpc];
in {
  "cloudflare_apiTokenFile.age".publicKeys = keys;
  "transmission_credentialsFile.age".publicKeys = keys;
  "silverbullet_credentialsFile.age".publicKeys = keys;
  "qbittorrent_conf.age".publicKeys = keys;
  "attic-environment-file.age".publicKeys = keys;
  "attic-signing-key.age".publicKeys = keys;
  "attic-token.age".publicKeys = keys;
  "nix-netrc.age".publicKeys = keys;
  "samba-creds.age".publicKeys = keys;
  "opencode-env.age".publicKeys = keys;
}

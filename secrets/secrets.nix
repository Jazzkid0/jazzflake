let
  keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOXr41H8R6YjEFGilGFw3k+KmuPyDaOofxctpQMmY18f jazzkid@jazzsl"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEQVZnbcapMI2cVH7/t7WYCcxDbVyQQYIWW4Q51K5CIO jazzkid@jazzserver"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIbpMhMLZqxJXZxKF8PsNtjV69h2HbRwA4HFRAURqjB4 jazzkid@jazznas"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDIN3rt+uOSH4HrmG/LiNb3r7rCBX3j5PGoy3MROYOjZ jazzkid@jazzpc"
  ];
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
}

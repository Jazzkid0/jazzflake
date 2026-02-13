let keys = [
  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIG5nQmbAPLBByAO4JzuhIEKLv5Bwnbz+6MLuiUrv23G jazzkid@jazznas" # old
  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAvWLv+pEt4tnil5IsMrh/BVqRZLbsuOZZ9MycuH8K6n jazzpc" # old
  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOXr41H8R6YjEFGilGFw3k+KmuPyDaOofxctpQMmY18f jazzkid@jazzsl"
  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEQVZnbcapMI2cVH7/t7WYCcxDbVyQQYIWW4Q51K5CIO jazzkid@jazzserver"
  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIbpMhMLZqxJXZxKF8PsNtjV69h2HbRwA4HFRAURqjB4 jazzkid@jazznas"
];
in
{
  "cloudflare_apiTokenFile.age".publicKeys = keys;
  "transmission_credentialsFile.age".publicKeys = keys;
  "qbittorrent_conf.age".publicKeys = keys;
}

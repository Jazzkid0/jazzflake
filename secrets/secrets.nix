let keys = [
  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFHJpS4qhtDcfcjD0cD0PmnWxay53Y5Xlf0mPOcSdtkL jazzkid@jazzserver"
  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIG5nQmbAPLBByAO4JzuhIEKLv5Bwnbz+6MLuiUrv23G jazzkid@jazznas"
  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAvWLv+pEt4tnil5IsMrh/BVqRZLbsuOZZ9MycuH8K6n jazzpc"
  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOXr41H8R6YjEFGilGFw3k+KmuPyDaOofxctpQMmY18f jazzkid@jazzsl"
];
in
{
  "cloudflare_apiTokenFile.age".publicKeys = keys;
  "transmission_credentialsFile.age".publicKeys = keys;
  "qbittorrent_conf.age".publicKeys = keys;
}

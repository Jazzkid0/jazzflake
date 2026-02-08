let
  jazzkid_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIG5nQmbAPLBByAO4JzuhIEKLv5Bwnbz+6MLuiUrv23G jazzkid@jazznas";
  jazznas_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHlJScwuL1jSVfLb6ke0n4mcrG1htSwtziTgBf9CAOVi";
  jazzserver_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILtHbdmyU16pT3LX0/YJjdRVAPLvDNyKeyPm8z1KNSC5";
  keys = [ jazzkid_key jazznas_key jazzserver_key ];
in
{
  "cloudflare_apiTokenFile.age".publicKeys = keys;
  "transmission_credentialsFile.age".publicKeys = keys;
}

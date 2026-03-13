{ ... }:
{
  nix.settings = {
    substituters= [
      "https://cachix.jazzkid.xyz"
    ];
    trusted-public-keys = [ "cachix.jazzkid.xyz:74drntauc/Zv2ihaTqSMYiGE7Rcdt481S6Q0phHDU3c=" ];
  };
}

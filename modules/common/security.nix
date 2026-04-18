{
  config,
  lib,
  pkgs,
  ...
}: {
  age.secrets.nix-netrc = {
    file = ../../secrets/nix-netrc.age;
    owner = "jazzkid";
    group = "users";
    mode = "0400";
  };

  nix.settings = {
    substituters = [
      "https://cachix.jazzkid.xyz/main"
    ];
    trusted-public-keys = [
      "cachix.jazzkid.xyz:74drntauc/Zv2ihaTqSMYiGE7Rcdt481S6Q0phHDU3c=" # might be wrong?
      "main:1XdAi4NruvfL1KT6MELYdyd9zSCenzA0pRupKxOMtHQ=" # as stated on jazznas
    ];
    netrc-file = config.age.secrets.nix-netrc.path;
  };
}

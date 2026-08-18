{
  pkgs,
  lib,
  sshKeys,
  ...
}: {
  imports = [
    ./networking.nix
  ];

  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
    };
    optimise = {
      automatic = true;
      dates = [
        "Tue 04:30"
      ];
      randomizedDelaySec = "1800";
    };
    # configuration.nix
  };

  users.users.root.openssh.authorizedKeys.keys = with sshKeys; [jazzsl jazzserver jazznas jazzpc];

  environment.systemPackages = with pkgs; [
    ripgrep
  ];
}

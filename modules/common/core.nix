{pkgs, lib, sshKeys, ...}: {
  imports = [
    ./networking.nix
  ];

  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";

  nix.settings.experimental-features = ["nix-command" "flakes"];

  users.users.root.openssh.authorizedKeys.keys = with sshKeys; [jazzsl jazzserver jazznas jazzpc];

  environment.systemPackages = with pkgs; [
    ripgrep
  ];
}

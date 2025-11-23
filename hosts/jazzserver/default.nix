{ ... }:
# Primary config, see `man configuration.nix`

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true; # Use the systemd-boot EFI boot loader.
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "jazzserver";
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # NEVER CHANGE THIS --------------------------------------|
  system.stateVersion = "24.05"; # Did you read the comment?|
  # --------------------------------------------------------|
}

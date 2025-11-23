{ pkgs, lib, ... }:
# System wide modules, defined within-user

{
  users.users.jazzkid = {
    isNormalUser = true;
    home = "/home/jazzkid";
    extraGroups = [ "networkmanager" "wheel" ]; # Enable ‘sudo’ for the user.
  };
  nix.settings.trusted-users = ["jazzkid"];

  nixpkgs.config.allowUnfree = true;

  services.nginx = {
    enable = true;
    virtualHosts."dev.jazzkid.xyz" = {
      locations."/".proxyPass = "http://localhost:8080";
    };
  };


  users.defaultUserShell = pkgs.zsh;

  environment.variables.EDITOR = "vim";
}

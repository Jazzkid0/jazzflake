{ pkgs, ... }: {
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  services.tailscale.enable = true;
  networking.firewall.trustedInterfaces = [ "tailscale0" ];

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    ripgrep
    htop
  ];
}

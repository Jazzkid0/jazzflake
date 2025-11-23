{ pkgs, ... }: {

  imports = [
    ./networking.nix
    ./security.nix
  ];

  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    ripgrep
    htop
    tmux
  ];
}

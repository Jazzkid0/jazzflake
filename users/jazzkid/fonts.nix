{ lib, pkgs, config, ... }:

{
  home.packages = with pkgs; [
    nerd-fonts.roboto-mono
  ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts.monospace = [
      "roboto-mono"
    ];
  };
}

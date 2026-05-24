final: prev: let
  slippi-launcher = final.callPackage ./pkgs/launcher {};
  slippi-netplay = final.callPackage ./pkgs/netplay {};
  slippi-playback = final.callPackage ./pkgs/playback {};
  slippi-netplay-beta = final.callPackage ./pkgs/netplay-beta {};
in {
  inherit
    slippi-launcher
    slippi-netplay
    slippi-playback
    slippi-netplay-beta
    ;

  slippi-launcher-desktop = final.callPackage ./pkgs/launcher-desktop {
    inherit (final) formats;
    inherit
      slippi-launcher
      slippi-netplay
      slippi-netplay-beta
      slippi-playback
      ;
  };

  slippi-check-updates = final.callPackage ./pkgs/check-updates {};
}

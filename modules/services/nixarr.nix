{
  config,
  pkgs,
  lib,
  nixarr,
  ...
}: {
  nixarr.enable = true;
  nixarr.mediaDir = "/srv/media/media-lib/";
}

{
  # fileSystems."/srv/media" = {
  #   device = "/dev/disk/by-uuid/1EA635EBA635C455";
  #   fsType = "ntfs-3g"; # TODO: reformat to btrfs when next disk is installed
  #   options = [ "uid=1001" "gid=992" "umask=0002" ];
  # };
  fileSystems."/srv/media" = {
    device = "/dev/disk/by-uuid/1d3b0924-b12b-4598-83f8-1c093d8b779e";
    fsType = "btrfs";
    options = [
      "compress=zstd"
      "autodefrag"
    ];
  };
}

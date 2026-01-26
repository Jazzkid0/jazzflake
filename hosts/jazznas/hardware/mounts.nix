{
  fileSystems."/srv/media" = {
    device = "/dev/disk/by-uuid/1EA635EBA635C455";
    fsType = "ntfs-3g"; # TODO: reformat to btrfs when next disk is installed
    options = [ "uid=1001" "gid=992" "umask=0002" ];
  };
}

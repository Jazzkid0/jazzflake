{
  fileSystems = {
    "/mnt/c" = {
      device = "/dev/disk/by-uuid/6A26CBB126CB7C97";
      fsType = "ntfs";
      options = [
        "uid=1000"
        "gid=100"
        "umask=000"
        "noatime"
        "big_writes"
      ];
    };
    "/mnt/d" = {
      device = "/dev/disk/by-uuid/42B81385B813769F";
      fsType = "ntfs";
      options = [
        "uid=1000"
        "gid=100"
        "umask=000"
        "noatime"
        "big_writes"
      ];
    };
    "/mnt/f" = {
      device = "/dev/disk/by-uuid/3E1A685C1A6812E7";
      fsType = "ntfs";
      options = [
        "uid=1000"
        "gid=100"
        "umask=000"
        "noatime"
        "big_writes"
      ];
    };
  };
}

{config, ...}: {
  age.secrets.samba-creds = {
    file = ../../../secrets/samba-creds.age;
    owner = "jazzkid";
    group = "users";
    mode = "0600";
  };

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
    # NAS mounts
    "/mnt/nas/media" = {
      device = "//nas.jazzkid.xyz/private";
      fsType = "cifs";
      options = [
        "uid=1000"
        "gid=100"
        "file_mode=0755"
        "dir_mode=0755"
        "x-systemd.automount"
        "x-systemd.idle-timeout=60"
        "vers=3.0"
        "credentials=${config.age.secrets.samba-creds.path}"
      ];
    };
  };
}

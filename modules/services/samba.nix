{ config, pkgs, ... }:

{
  environment.systemPackages = [ pkgs.samba ];

  users.groups.smb = {};

  users.users.smbuser = {
    isNormalUser = true;
    description = "samba user";
    extraGroups = [ "smb" ];
    createHome = true;
    # hashedPassword or mkpasswd ??
  };

  services.samba = {
    enable = true;
    openFirewall = true;

    settings = {
      global = {
        # "protocol" = "SMB3";
        "workgroup" = "WORKGROUP";
        "server string" = "samba";
        "netbios name" = "nixos-samba";
        "security" = "user";
        "guest account" = "nobody";
        "map to guest" = "bad user";
        "hosts allow" = "127.0.0.1 192.168.1. 100.64.0.0/10";
        "hosts deny" = "";
      };

      "private" = {
        "path" = "/srv/media";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0664";
        "directory mask" = "0775";
        "force user" = "smbuser";
        "force group" = "media";
      };

      "public" = {
        "path" = "/srv/media/public";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "smbuser";
        "force group" = "media";
      };
    };
  };
  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 445 137 138 ];
}

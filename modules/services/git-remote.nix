{pkgs, sshKeys, ...}: {
  users.users.git = {
    isSystemUser = true;
    group = "git";
    home = "/srv/git";
    shell = "${pkgs.git}/bin/git-shell";
    openssh.authorizedKeys.keys = with sshKeys; [ jazzpc jazznas jazzserver ];
  };
  users.groups.git = {};

  environment.systemPackages = [pkgs.git];
}

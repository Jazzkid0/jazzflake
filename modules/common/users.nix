{pkgs, sshKeys, ...}: {
  age.identityPaths = ["/home/jazzkid/.ssh/id_ed25519"];

  nix.settings.trusted-users = ["jazzkid"];

  programs.zsh.enable = true;

  users.users.jazzkid = {
    isNormalUser = true;
    description = "jazzkid";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = builtins.attrValues sshKeys;
  };

  users.users.root.openssh.authorizedKeys.keys = with sshKeys; [jazzsl jazzserver jazznas jazzpc];
}

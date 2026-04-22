{
  pkgs,
  sshKeys,
  user,
  ...
}: {
  users.users.${user} = {
    isNormalUser = true;
    description = user;
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = builtins.attrValues sshKeys;
  };

  age.identityPaths = ["/home/${user}/.ssh/id_ed25519"];

  nix.settings.trusted-users = ["${user}"];
}

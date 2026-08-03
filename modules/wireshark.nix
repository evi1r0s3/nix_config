{ nixpkgs-default, user-name, ... }:
{
  programs.wireshark = {
    enable = true;
    package = nixpkgs-default.wireshark;
  };
  users.users.${user-name}.extraGroups = [ "wireshark" ];
}

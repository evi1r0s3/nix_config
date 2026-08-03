{ nixpkgs-default, user-name, ... }:
{
  virtualisation.docker.enable = true;
  users.users.${user-name}.extraGroups = [ "docker" ];
  environment.systemPackages = [
    nixpkgs-default.docker-compose
  ];
  nixpkgs.config.permittedInsecurePackages = [
    "docker-28.5.2"
  ];
  #virtualisation.docker.daemon.settings = {
  #  registry-mirrors = [
  #    "https://doublezonline.cloud"
  #    "https://docker.fxxk.dedyn.io"
  #    "https://atomhub.openatom.cn"
  #    "https://hub.rat.dev"
  #    "https://docker.wanpeng.top"
  #  ];
  #};
}

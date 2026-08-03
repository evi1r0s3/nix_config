{ nixpkgs-default, ... }:
{
  environment.systemPackages = with nixpkgs-default; [
    seadrive-gui
  ];
}

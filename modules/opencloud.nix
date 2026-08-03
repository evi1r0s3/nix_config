{ nixpkgs-unstable, ... }:
{
  environment.systemPackages = with nixpkgs-unstable; [
    opencloud-desktop
  ];
}

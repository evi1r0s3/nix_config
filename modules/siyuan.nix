{ nixpkgs-unstable, ... }:
{
  environment.systemPackages = with nixpkgs-unstable; [
    siyuan
  ];
}

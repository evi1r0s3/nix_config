{ nixpkgs-unstable, ... }:
{
  environment.systemPackages = with nixpkgs-unstable; [
    trilium-desktop
  ];
}

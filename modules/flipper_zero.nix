{ nixpkgs-default, ... }:
{
  environment.systemPackages = with nixpkgs-default; [
    qFlipper
  ];
  hardware.flipperzero.enable = true;
}

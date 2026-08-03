{ nixpkgs-default, ... }:
{
  environment.systemPackages = with nixpkgs-default; [ telegram-desktop ];
}

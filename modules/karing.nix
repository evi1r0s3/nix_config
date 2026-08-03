{ nixpkgs-default, ... }:
{
    environment.systemPackages = with nixpkgs-default; [
        karing
    ];
}

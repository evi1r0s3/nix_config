{ nixpkgs-default, ... }:
{
    #environment.systemPackages = with nixpkgs-default; [
    #    cloudflare-warp
    #];
    services.cloudflare-warp = {
        enable = true;
    };
    environment.systemPackages = [
        nixpkgs-default.cloudflared
    ];
}

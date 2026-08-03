{ nixpkgs-default, user-name,nur-pkgs, ... }:
{
  environment.systemPackages = with nixpkgs-default; [
    (nixpkgs-default.urh.override { USRPSupport = true; })
    nixpkgs-default.hackrf
    nixpkgs-default.uhd
    nixpkgs-default.gnuradio
    nur-pkgs.repos.sikmir.gps-sdr-sim
  ];

  hardware.hackrf.enable = true;
  users.users.${user-name}.extraGroups = [ "plugdev" ];
}

{ nixpkgs-default, ... }:

{
  environment.systemPackages = with nixpkgs-default; [
    nmap
    rustscan
    socat
    metasploit
    sqlmap
    hashcat
    dirb
    gobuster
    hping
    aircrack-ng
    netdiscover
    john
    netcat
    ffuf
    tcpdump
    kismet
    binwalk
    socat
    can-utils
    cve-bin-tool
    inetutils #telnent
    netcat #nc
    ghidra-bin
    thc-hydra
    seclists
  ];
  nixpkgs.config.permittedInsecurePackages = [
    "segger-jlink-qt4-796s"
  ];
  networking.firewall = {
    allowedTCPPorts = [
      1337
      4444
    ];
  };
}

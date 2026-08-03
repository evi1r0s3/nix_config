{ nixpkgs-default, ... }:
{
  environment.systemPackages = with nixpkgs-default; [
    (python312.withPackages (python-pkgs: with python-pkgs; [
      pwntools
      scapy
      requests
      # Binary Ninja
      hypercorn
      mcp
      anyio
      pydantic
      pydantic-settings
    ]))
  ];
}

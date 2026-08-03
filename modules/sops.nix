{ nixpkgs-default, ... }:
{
  environment.systemPackages = with nixpkgs-default; [
    sops
    age
  ];

  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";

    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    };
  };
}

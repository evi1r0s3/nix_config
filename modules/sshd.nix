{ ... }:
{
  services.openssh = {
    enable = true;
    settings = {
      AllowUsers = [ "evi1_f4iry" ];
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };
}

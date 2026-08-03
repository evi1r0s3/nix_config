{ nur-pkgs, ... }:
{
  environment.systemPackages = with nur-pkgs.repos; [
    xddxdd.dingtalk
  ];
}

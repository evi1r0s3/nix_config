{
  security.sudo.extraConfig = "Defaults env_reset,timestamp_timeout=-1";
  # 因为使用polkit，控制了，所以在对服务的控制上不需要配置sudo，因为polkit已经接管了
  # 但是还是保留这个例子，以后用
  #security.sudo.extraRules = [{
  #  users = [ "${user-name}" ];
  #  commands = [
  #    {
  #      command = "/run/current-system/sw/bin/systemctl start singbox";
  #      options = [ "NOPASSWD" ];
  #    }
  #  ];  
  #}];
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (
        subject.isInGroup("wheel")
          && (
            action.id == "org.freedesktop.systemd1.manage-units"
          )
        )
      {
        return polkit.Result.YES;
      }
    });
  '';
  networking.firewall = {
    allowedTCPPorts = [
      1337
      1338
      4444
    ];
  };
}

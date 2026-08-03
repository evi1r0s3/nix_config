{ pkgs, ... }:
{
  time.timeZone = "Asia/Shanghai";
  services.chrony = {
    enable = true;
    servers = [
      "ntp.aliyun.com" # 阿里
      "time1.cloud.tencent.com" # 腾讯
      "cn.ntp.org.cn" # 中国
      "time.cloudflare.com"
      "time.google.com"
      "0.nixos.pool.ntp.org"
      "1.nixos.pool.ntp.org"
      "2.nixos.pool.ntp.org"
      "3.nixos.pool.ntp.org"
    ];
  };
  systemd = {
    # Fix NTP startup dependencies
    services = {
      chronyd = {
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
      };
    };
  };

  systemd.targets.time-synced = {
      description = "System Time Synchronized";
      wantedBy = [ "multi-user.target" ];
      requires = [ "chrony-time-sync-wait.service" ];
      after = [ "chrony-time-sync-wait.service" ];
    };

  systemd.services.chrony-time-sync-wait = {
    description = "Wait for time synchronization from chrony";
    after = [ "chronyd.service" ];
    requires = [ "chronyd.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      StandardOutput = "journal";
      TimeoutStartSec = "infinity";
      ExecStart = "${
        pkgs.writeShellApplication {
          name = "wait-for-time-sync";
          runtimeInputs = [
            pkgs.chrony
            pkgs.coreutils
          ];
          text = ''
            if timedatectl | grep -q "System clock synchronized: yes"; then
              exit 0
            fi
              while true; do
                sleep 10
                if timedatectl | grep -q "System clock synchronized: yes"; then
                  exit 0
                fi
                chronyc makestep
              done
          '';
        }
      }/bin/wait-for-time-sync";
    };
  };
}

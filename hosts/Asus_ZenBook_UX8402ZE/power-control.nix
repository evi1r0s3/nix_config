{
  services.tlp = {
    enable = true;
    settings = {
      # 从性能高到低
      # performance 性能
      # balance_performance 平衡性能
      # default 默认配置，一般是平衡性能或者厂家预设
      # balance_power 平衡省电
      # power 省电
      # 
      # 性能自动缩放的规则策略
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "balance_performance";
      # CPU 的能源/性能策略
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_performance";

      # wifi 节能模式
      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "on";
      # 禁用涡轮增压功能，只在有线供电时开启，
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
      CPU_BOOST_ON_SAV = 0;
      CPU_HWP_DYN_BOOST_ON_AC = 1;
      CPU_HWP_DYN_BOOST_ON_BAT = 0;
      CPU_HWP_DYN_BOOST_ON_SAV = 0;

      # CPU性能范围限制
      CPU_MIN_PERF_ON_AC = 85;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 45;
      CPU_MAX_PERF_ON_BAT = 95;

      # 电池过冲保护
      START_CHARGE_THRESH_BAT0 = 50; # 40 and below it starts to charge
      STOP_CHARGE_THRESH_BAT0 = 95;  # 80 and above it stops charging
    };
  };
}

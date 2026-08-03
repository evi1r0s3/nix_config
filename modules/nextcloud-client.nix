{ nixpkgs-default, ... }:
{
  environment.systemPackages = with nixpkgs-default; [
    nextcloud-client
  ];
  # 开启vfs功能也就是虚拟文件功能才能释放本地存储空间
  # ～/.config/Nextcloud/nextcloud.cfg
  #  #   [General]
      #   showExperimentalOptions=true
      # 开启后在客户端的setting里面，已经挂载的右边省略号选择打开虚拟文件支持
}

{ nixpkgs-default, lib, ... }:
{
  programs.thunar = {
    enable = true;
    # 插件
    plugins = with nixpkgs-default; [
      # TODO：archive 功能暂时还有问题
      #xfce.thunar-archive-plugin
      #xfce.thunar-volman
      #xfce.thunar-media-tags-plugin
      thunar-archive-plugin
      thunar-volman
      thunar-media-tags-plugin
    ];
  };
  environment.systemPackages = with nixpkgs-default; [
    kdePackages.ark
    ffmpegthumbnailer
    libgsf
    gvfs
  ];
  # 因为未使用xfce4作为桌面环境，所以开启xfconf程序用于保存xfce配置选项
  programs.xfconf.enable = true;
  # thunar的额外功能，挂载和图片预览
  services.gvfs = {
    enable = true;
    package = lib.mkForce nixpkgs-default.gnome.gvfs;
  };
  services.tumbler.enable = true;
  services.davfs2.enable = true;
}

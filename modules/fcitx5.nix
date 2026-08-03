{ nixpkgs-default, ... }:
{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with nixpkgs-default; [
      fcitx5-gtk
      qt6Packages.fcitx5-chinese-addons
    ];
  };
  environment.sessionVariables = {
    XIM = "fcitx";
    XMODIFIERS = "@im=fcitx";
    # 已经使用了wayland前端，可以不设置以下
    #GTK_IM_MODULE = "fcitx";
    #QT_IM_MODULE = "fcitx";
  };
  # Release 24.05 (“Uakari”, 2024.05/31)
  # https://nixos.org/manual/nixos/stable/release-notes#sec-release-24.05-notable-changes
  # 将 i18n.inputMethod.enabled 设置为 fcitx5 时，它不再创建相应的 systemd 用户服务。
  # 它现在依赖于 XDG 自动启动文件在桌面会话中启动和正常工作。
  # 如果您只使用窗口管理器而没有桌面管理器，则需要启用 services.xserver.desktopManager.runXdgAutostartIfNone
  # 或使用该 dex 软件包才能 fcitx5 工作。
  # services.xserver.desktopManager.runXdgAutostartIfNone = true;
}

{ ... }:
{
  # 限制启动项目数量
  boot.loader.systemd-boot.configurationLimit = 10;
  # 自动清理
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 10d";
  };
  # 优化存储
  # 如果设置为 true，Nix 会自动检测存储中具有相同内容的文件，并将它们替换为单个副本的硬链接。
  # 这可以节省磁盘空间。如果设置为 false（默认值），您仍然可以运行 nix-store --optimise 来删除重复文件。
  # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
  nix.settings.auto-optimise-store = true;
}

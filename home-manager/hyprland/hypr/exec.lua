hl.on("hyprland.start", function()
  hl.exec_cmd("hyprlock")
  hl.exec_cmd("brightnessctl -d asus")
  -- 通知
  hl.exec_cmd("mako")
  hl.exec_cmd("notify-send -u normal")
  -- 控制栏
  -- hl.exec_cmd("eww daemon")
  -- hl.exec_cmd("eww open main")
  -- hl.exec_cmd("waybar")
  hl.exec_cmd("ashell")
  -- 剪贴板
  hl.exec_cmd("wl-paste --type text --watch cliphist store --Stores only text data")
  hl.exec_cmd("wl-paste --type image --watch cliphist store --Stores only image data")
  -- 输入法
  hl.exec_cmd("fcitx5 -d --replace")
  hl.exec_cmd("fcitx5-remote -r")
  -- hl.exec_cmd('echo "Xft.dpi: 172" | xrdb -merge')
  hl.exec_cmd('xrdb ~/.Xresources')
  -- 托盘
  hl.exec_cmd("nm-applet")
  -- 钥匙包，必须为钥匙包配置密码为空，否则每次都需要输入钥匙包密码，必须使用钥匙包否则每次都会要求wifi等其他需要保存的密码
  hl.exec_cmd("kwalletd6")
  -- 壁纸
  hl.exec_cmd("hyprpaper")
  -- flatpak，为flatpak安装的软件包调节必要的权限和缩放
  hl.exec_cmd("flatpak override --user --env=QT_SCREEN_SCALE_FACTORS=1.8 --env=XCURSOR_SIZE=24 --filesystem=xdg-download:rw com.dingtalk.DingTalk")
end)

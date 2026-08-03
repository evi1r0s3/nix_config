-- nvidia
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("GBM_BACKEND", "nvidia-drm")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("_JAVA_OPTIONS", "-Dsun.java2d.uiScale=2")

-- 这里配置hyprcursor尺寸和主题但是gtk等不支持服务端指针，在nix中配置了x和gtk的指针主题尺寸
hl.env("HYPRCURSOR_THEME", "rose-pine-hyprcursor")
hl.env("HYPRCURSOR_SIZE", "48")

-- 中文环境
hl.env("LANG", "zh_CN.UTF-8")

-- HiDPI
hl.config = ({
  xwayland = {
    force_zero_scaline = true
  }
})
--
hl.env("QT_QPA_PLATFORMTHEME", "hyprqt6engine")
hl.env("XCURSOR_SIZE", "48")

hl.env("GDK_SCALE", "1.75")
hl.env("GDK_DPI_SCALE", "1.75")
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")
-- QT
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1.75")
hl.env("QT_SCREEN_SCALE_FACTORS", "1.75")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_IM_MODULE", "fcitx")
hl.env("QT_FONT_DPI", "144")
-- electron 相关的都使用wayland,如vscode等
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")
hl.env("NIXOS_OZONE_WL", "1")
hl.env("ELECTRON_FORCE_DEVICE_SCALE_FACTOR", "1.75")

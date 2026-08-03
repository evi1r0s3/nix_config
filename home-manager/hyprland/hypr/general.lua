hl.config({
  general = {
    -- 窗户周围边框的大小
    border_size = 2,
    -- 窗口间距，也支持 CSS 样式间距（上、右、下、左 -> 5、10、15、20）
    gaps_in = 2,
    -- 窗口与显示器边缘之间的间隙，也支持 CSS 样式间隙（上、右、下、左 -> 5、10、15、20）
    gaps_out = 5,
    -- 浮动窗口的窗口与显示器边缘之间的间隙，也支持 CSS 样式间隙（上、右、下、左 -> 5 10 15 20）。-1 表示默认值。
    float_gaps = -1,
    -- 工作区之间的间隙。带有 gaps_out 的堆栈。
    gaps_workspaces = 0,

    col = {
      -- 非活动窗口的边框颜色
      inactive_border = { colors = { "rgb(9932cc)", "rgb(8b008b)" }, angle = 45 },
      -- 活动窗口的边框颜色
      active_border = { colors = { "rgb(ff00ff)", "rgb(00ffff)" }, angle = 90 },
      -- 无法添加到组的窗口的非活动边框颜色
      nogroup_border = 0xffff00ff,
      -- 无法添加到组的窗口的活动边框颜色
      nogroup_border_active = 0xffff00ff,
    },
    -- 布局 [dwindle/master/scrolling/monocle]
    layout = dwindle,
    -- 如果为真，则在将焦点移动到未找到窗口的方向时，不会回退到下一个可用窗口。
    no_focus_fallback = false,
    -- 可以通过点击并拖动窗口边缘和间隙来调整窗口大小
    resize_on_border = true,
    -- 边框周围的可点击和拖动区域，仅当启用 general:resize_on_border 时使用。
    extend_border_grab_area = 10,
    -- 当鼠标悬停在边框上时显示图标，仅当启用 general:resize_on_border 时使用。
    hover_icon_on_border = true,
    -- 用于允许撕裂发生的主开关。请参阅https://wiki.hyprland.org/Configuring/Tearing/
    allow_tearing = false,
    -- 强制浮动窗口在调整大小时使用特定角（从左上角顺时针方向为 1-4，0 表示禁用）
    resize_corner = 0,
    -- 吸附
    snap = {
      -- 启用浮动窗口的吸附功能
      enabled = true,
      -- 窗口对齐前的最小像素间隙
      window_gap = 10,
      -- 窗口边缘与显示器边缘贴合前的最小像素间隙
      monitor_gap = 10,
      -- 如果true，窗口将自动对齐，使它们之间只留一个边框的距离。
      border_overlap = false,
      -- 如果为真，则对齐功能会考虑窗口之间的间隙（在 general:gaps_in 中设置）。
      respect_gaps = true,
    },
  },
})

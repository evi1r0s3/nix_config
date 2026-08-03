hl.config = ({
  input = {
    -- XKB 键盘参数
    kb_layout = "us",
    -- 指定光标移动是否以及如何影响窗口焦点。[0/1/2/3]
    follow_mouse = 1,
    -- 鼠标移动到其下方窗口获得焦点所需的最小逻辑像素距离。仅当 follow_mouse = 1 时有效。
    follow_mouse_threshold = 0.0,
    -- 控制窗口关闭时的焦点行为。设置为 0 时，焦点将转移到下一个候选窗口。设置为 1 时，焦点将转移到光标下的窗口。[0/1]
    focus_on_close = 1,
    -- 如果禁用此功能，当 follow_mouse=1 时，鼠标焦点不会切换到悬停的窗口，除非鼠标越过窗口边界。
    mouse_refocus = true,
    -- 鼠标输入灵敏度。数值范围限制在 -1.0 到 1.0 之间
    sensitivity = 0,
    -- 触摸板
    touchpad = {
      -- 反转滚动方向。启用后，滚动将直接移动内容，而不是操作滚动条。
      natural_scroll = true,
      -- 用 1、2 或 3 个手指轻触触摸板，将分别发送 LMB、RMB 和 MMB 指令。
      tap_to_click = true,
    },
    -- 触摸设备
    -- touchdevice = {},
    -- 虚拟键盘
    virtualkeyboard = {
      -- 与其他键盘统一按键按下状态和修饰键状态。
      share_states = true,
      -- 关闭时，虚拟键盘上的所有按键都会被释放。
      release_pressed_on_close = true,
    },
    -- tablet = {},
    -- tablettool = {},
  },
  -- 手势
  gestures = {
    -- 启用从触摸屏边缘滑动进入工作区
    workspace_swipe_touch = true,
  },
  -- 光标
  cursor = {
    -- 禁用硬件光标。0 - 如果可能的话使用硬件光标，1 - 不使用硬件光标，2 - 自动（撕画时禁用）
    no_hardware_cursors = 0,
    -- 几秒钟内，光标多久不动以隐藏它。设置为 0，表示永远不存在。
    inactive_timeout = 0,
    -- 启动时光标的默认显示器名称（详见 Hyprctl 显示器名称)
    default_monitor = "eDP-1",
    -- 让硬件光标使用 CPU 缓冲区。在 Nvidia 上必须有硬件光标。0 - 关闭，1 - 开启，2 - 自动（仅限 Nvidia）
    use_cpu_buffer = 1,
  },
})

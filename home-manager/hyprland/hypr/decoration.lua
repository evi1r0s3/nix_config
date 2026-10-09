hl.config({
  decoration = {
    -- 圆角半径（像素为单位）
    rounding = 15,
    -- 曲率
    rounding_power = 2.5,
    -- 活动窗口的不透明度。[0.0 - 1.0]
    active_opacity = 1.0,
    -- 非活动窗口的不透明度。[0.0 - 1.0]
    inactive_opacity = 1.0,
    -- 全屏窗口的不透明度。[0.0 - 1.0]
    fullscreen_opacity = 1.0,
    -- 启用modal窗口父窗口的变暗功能
    dim_modal = true,
    -- 启用使非活动窗口变暗的功能
    dim_inactive = false,
    -- 非活动窗口应调暗多少 [0.0 - 1.0]
    dim_strength = 0.5,
    -- 当打开特殊工作区时，屏幕其余部分应调暗多少？[0.0 - 1.0]
    dim_special = 0.2,
    -- dimaround 窗口规则的暗化幅度应为多少。[0.0 - 1.0]
    dim_around = 0.4,
    -- 指向要在渲染结束时应用的自定义着色器的路径。examples/screenShader.frag
    -- screen_shader =
    -- 窗口边框是否应该成为窗口的一部分
    -- border_part_of_window = false,
    -- 模糊
    blur = {
      -- 启用窗口背景模糊
      enabled = true,
      -- 模糊大小（距离）
      size = 5,
      -- 模糊执行的次数
      passes = 1,
      -- 使模糊图层忽略窗口的不透明度。
      ignore_opacity = true,
      -- 是否启用进一步的模糊优化。建议启用，因为它可以大幅提升性能。
      new_optimizations = true,
      -- 启用后，浮动窗口在模糊处理中将忽略平铺窗口。仅当 `new_optimizations` 为真时可用。这将显著降低浮动窗口模糊处理的开销。
      xray = true,
    },
    -- 阴影
    shadow = {
      -- 启用窗口阴影
      enabled = true,
      -- 布局中的阴影范围（“大小”）以像素为单位
      range = 4,
      -- 衰减的功率是多少（功率越大，衰减越快）[1 - 4]
      render_power = 3,
      -- 启用后，阴影会变得非常锐利，类似于无限渲染能力。
      sharp = false,
      -- 阴影的颜色。Alpha 值决定阴影的不透明度。
      color = "rgba(1a1a1aee)",
    },
    -- Glow = {},
    -- motion_blur = {},
  },
})

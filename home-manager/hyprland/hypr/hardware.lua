hl.monitor({ output = "eDP-1", mode = "2880x1800@120.00100", position = "0x0", scale = 1 })
hl.monitor({ output = "DP-1", mode = "2880x864@120.01600", position = "auto-down", scale = 1 })
hl.monitor({ output = "", mode = "highres", position = "auto-left", scale = 1  })
-- nvidia
hl.config({
    opengl = { nvidia_anti_flicker = true },
})

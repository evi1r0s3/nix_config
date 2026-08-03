--
hl.window_rule({ match = { class = ".*"}, suppress_event = "maximize" })
hl.window_rule({ match = { class = ".*"}, opacity = "0.95 override" })
--
hl.window_rule({ match = { class = "^(org.kde.polkit-kde-authentication-agent-1)$"}, float = true })
hl.window_rule({ match = { class = "^(nm-connection-editor)$"}, float = true })
hl.window_rule({ match = { class = "^(blueman-manager)$"}, float = true })

hl.window_rule({ match = { class = "^(wlogout)$"}, float = true })
-- thunar
hl.window_rule({ match = { title = "^(thunar)$"}, float = true, size = {"(monitor_w*0.7)", "(monitor_h*0.5)"}, center = true })
-- nmtui
hl.window_rule({ match = { title = "^(nmtui)$"}, float = true, size = {"(monitor_w*0.7)", "(monitor_h*0.5)"}, center = true })
--
hl.window_rule({ match = { title = "^(打开)$"}, center = true })
-- magic workspace
hl.window_rule({ match = { workspace = "special:magic"}, float = true, size = {"(monitor_w*0.65)", "(monitor_h*0.35)"}, center = true })
-- wechat
hl.window_rule({ match = { title = "^(微信)$"}, float = true, center = true, size = {"(monitor_w*0.55)", "(monitor_h*0.75)"}, no_blur = true, no_shadow = true })
-- wemeet
hl.window_rule({ match = { class = "wemeetapp", title = "wemeetapp" }, no_blur = true, no_shadow = true })

-- Fix some dragging issues with XWayland
hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

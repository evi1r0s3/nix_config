local VAR = require("var")
--
hl.bind(VAR.mainMod .. " + escape", hl.dsp.window.close())
hl.bind(VAR.mainMod .. " + SHIFT + escape", hl.dsp.window.kill())
--
hl.bind(VAR.mainMod .. " + T", hl.dsp.exec_cmd(VAR.TERMINAL))
hl.bind(VAR.mainMod .. " + B", hl.dsp.exec_cmd(VAR.BROWSER))
hl.bind(VAR.mainMod .. " + R", hl.dsp.exec_cmd(VAR.RUNNER))
hl.bind(VAR.mainMod .. " + E", hl.dsp.exec_cmd(VAR.EDITOR))
hl.bind(VAR.mainMod .. " + F", hl.dsp.exec_cmd(VAR.FILE_MANAGER))
hl.bind(VAR.mainMod .. " + I", hl.dsp.exec_cmd(VAR.IDE))
hl.bind(VAR.mainMod .. " + H", hl.dsp.exec_cmd(VAR.HELPER))
hl.bind(VAR.mainMod .. " + N", hl.dsp.exec_cmd(VAR.NOTE))
--
hl.bind(VAR.mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(VAR.mainMod .. " + V", hl.dsp.exec_cmd("cliphist list | tofi | cliphist decode | wl-copy"))
--
hl.bind("CTRL + SHIFT + 5", hl.dsp.exec_cmd('grim -g "$(slurp)" - | swappy -f -'))
hl.bind("CTRL + SHIFT + 6", hl.dsp.exec_cmd('wf-recorder -g "$(slurp)" -a -f /home/evi1_f4iry/Videos/`date +%Y_%m_%d_%H_%M_%S`.mp4'))
-- 浮动
hl.bind(VAR.mainMod .. " + SHIFT + W", hl.dsp.window.float({ action = "toggle" }))
hl.bind(VAR.mainMod .. " + W", hl.dsp.window.fullscreen({ action = "toggle" }))
-- 功能
-- 亮度控制
hl.bind("code:232", hl.dsp.exec_cmd("brightnessctl -d intel_backlight set 10%- && brightnessctl -d asus_screenpad set $(($(brightnessctl -m -d intel_backlight | awk -F, '{print substr($4, 0, length($4)-1)}')/2))%"), { repeating = true })
hl.bind("code:232", hl.dsp.exec_cmd("brightnessctl -d intel_backlight set 10%+ && brightnessctl -d asus_screenpad set $(($(brightnessctl -m -d intel_backlight | awk -F, '{print substr($4, 0, length($4)-1)}')/2))%"), { repeating = true })
-- 音量控制
hl.bind("code:123", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 && wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), { repeating = true })
hl.bind("code:122", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 && wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { repeating = true })
hl.bind("code:232", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
hl.bind("code:232", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"))
-- 其他功能按键，使用wev监控事件，可识别keycode
-- FNF6:199,FF7: ,FF8:33,FF10:220,FF11:133,FF12:156,prtsc:107,asus_pad_switch:248,asus_pad_off:248
-- 移动resize，super + 鼠标左右键
-- Move/resize windows with VAR.mainMod + LMB/RMB and dragging
hl.bind(VAR.mainMod .. " + mouse:272", hl.dsp.window.drag())
hl.bind(VAR.mainMod .. " + mouse:273", hl.dsp.window.resize())
-- 
-- Scroll through existing workspaces with VAR.mainMod + scroll
hl.bind(VAR.mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(VAR.mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
-- workspace
for i = 1, 9 do
    hl.bind(VAR.mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
    hl.bind(VAR.mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end
hl.bind(VAR.mainMod .. " + 0", hl.dsp.focus({ workspace = "10" }))
hl.bind(VAR.mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = "10"}))
hl.bind(VAR.mainMod .. " + quoteleft", hl.dsp.focus({ workspace = "special:magic" }))
hl.bind(VAR.mainMod .. " + SHIFT + quoteleft", hl.dsp.window.move({ workspace = "special:magic" }))

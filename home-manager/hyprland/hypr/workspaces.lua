local VAR = require("var")
-- 工作区
hl.workspace_rule({ workspace = "1", monitor = "eDP-1", default = true })
hl.workspace_rule({ workspace = "2", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "3", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "4", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "5", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "6", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "7", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "8", monitor = "eDP-1" })
-- 下屏幕
hl.workspace_rule({ workspace = "10", monitor = "DP-1", default = true, on_created_empty = "[f2]" .. VAR.TERMINAL })
-- 扩展屏
hl.workspace_rule({ workspace = "9", monitor = "", default = true, on_created_empty = VAR.TERMINAL })
-- 特殊工作区
hl.workspace_rule({ workspace = "special:magic", on_created_empty = VAR.TERMINAL })

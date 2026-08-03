;;; init-ui.el --- UI Configuration.	-*- lexical-binding: t -*-
;; evi1_f4iry
;;; Commentary:
;;
;; Define UI.
;;
;;; Code:

;; ------------------------------------
;; 启动窗口

;;（可选）设定启动图形界面时的初始 Frame 宽/高（字符数）
;; (add-to-list 'default-frame-alist '(width . 90))
;; (add-to-list 'default-frame-alist '(height . 55))
;; 初始启动位置调整，根据界面宽度
;; (set-frame-position (selected-frame) (- (/ (display-pixel-width) 3) 190) (- (/ (display-pixel-height) 2) 110))
;; 使用全屏
;; (set-frame-parameter nil 'fullscreen 'fullboth)

;; ------------------------------------
;; 欢迎界面

;; 关闭启动 Emacs 时的欢迎界面
(setq inhibit-startup-message t)
;; 使用 dashboard 启动界面
(use-package dashboard
             :demand t
             :config
             (dashboard-setup-startup-hook))
;; 在使用守护进程的模式下同样启用
(setq initial-buffer-choice
      (lambda () (get-buffer "*dashboard*")))
;; title
(setq dashboard-banner-logo-title "Be obsessed, or be average.")
(setq dashboard-footer-messages '("帝力于我何有哉; 不疯魔，不成活。 "))
;; banner
(setq dashboard-startup-banner
      (expand-file-name
        (if (display-graphic-p) "./elements/logo.png" "./elements/banner.txt") user-emacs-directory))
;; Value can be
;; 'official which displays the official emacs logo
;; 'logo which displays an alternative emacs logo
;; 1, 2 or 3 which displays one of the text banners
;; "path/to/your/image.gif", "path/to/your/image.png" or "path/to/your/text.txt" which displays whatever gif/image/text you would prefer
;; 横向居中
(setq dashboard-center-content t)
;; 垂直居中
(setq dashboard-vertically-center-content t)
;; 不显示快速跳转提示
(setq dashboard-show-shortcuts nil)
;; 显示的类别数量
(setq dashboard-items '((recents  . 5)
                        (bookmarks . 5)
                        (projects . 5)
                        (agenda . 5)
                        (registers . 5)))
;; 其他选项见`github'

;; ------------------------------------
;; 基础界面

;; 标题栏显示绝对路径
;; (setq frame-title-format '("" "%b <%f> @ Emacs " emacs-version))
;; 标题栏显示版本及自定义信息
(setq frame-title-format '("evi1_f4iry @ Emacs " emacs-version))
(use-package solaire-mode
             :hook (after-init . solaire-global-mode))
;; ------------------------------------
;; 光标

;; 非当前选中的窗口不显示光标
(setq cursor-in-non-selected-windows t)
;; 光标改为竖线
(setq-default cursor-type 'bar)
;; 全局光标所在行高亮
(global-hl-line-mode nil)

;; ------------------------------------
;; 行列
;; Show line numbers
(use-package display-line-numbers
             :custom
             (display-line-numbers-grow-only t)
             ;; 配置行号的初始位数为3位，防止增行到100时行号区域晃动
             (display-line-numbers-width 3)
             ;; relative相对，visual绝对，设置为相对行号
             (display-line-numbers-type 'relative)
             (display-line-numbers-major-tick t)
             :hook
             (conf-mode . display-line-numbers-mode)
             (prog-mode . display-line-numbers-mode)
             (text-mode . display-line-numbers-mode)
             :after
             ;; 因为主题会修改行号一栏，所以行号的face设置应在主题之后
             (dracula-theme)
             :config
             ;; 所有行号的高度，和汉字一个尺寸，这样就能避免由于中英字体尺寸配置缩放系数
             ;; 等宽而导致行高输入抖动，使用height限制高度而不是直接设置字体字号是因为可以
             ;; 更精细的配置，尽量减少行距
             (set-face-attribute 'line-number nil :foreground "#6272A4" :background "#282A36")
             ;; 当前行号颜色和加粗
             (set-face-attribute 'line-number-current-line nil :foreground "#ff92df" :weight 'bold)
             )
;; 设置单行代码长度提示
(setq-default fill-column 90)
(add-hook 'after-init-hook 'global-display-fill-column-indicator-mode)

;; ------------------------------------
;; 符号及标识处理

;; 编程模式下，光标在括号上时高亮另一个括号
(add-hook 'prog-mode-hook #'show-paren-mode)
;; 彩虹括号
(use-package rainbow-delimiters
             :hook (prog-mode . rainbow-delimiters-mode))

;; 所有图标支持
(use-package all-the-icons
             :if (display-graphic-p)
             :config
             ;; Use 'prepend for the NS and Mac ports or Emacs will crash.
             (set-fontset-font t 'unicode (font-spec :family "all-the-icons") nil 'append)
             (set-fontset-font t 'unicode (font-spec :family "file-icons") nil 'append)
             (set-fontset-font t 'unicode (font-spec :family "Material Icons") nil 'append)
             (set-fontset-font t 'unicode (font-spec :family "github-octicons") nil 'append)
             (set-fontset-font t 'unicode (font-spec :family "FontAwesome") nil 'append)
             (set-fontset-font t 'unicode (font-spec :family "Weather Icons") nil 'append))

;;(use-package all-the-icons
;;  :config
;;  (set-fontset-font t 'symbol "Apple Color Emoji")
;;  (set-fontset-font t 'symbol "Noto Color Emoji" nil 'append)
;;  (set-fontset-font t 'symbol "Segoe UI Emoji" nil 'append)
;;  (set-fontset-font t 'symbol "Symbola" nil 'append)
;; org-mode 下获得更好的标识符号
;;(use-package org-bullets
;;  :config
;;(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))
;; 相同字符串高亮，选择之后使用F3切换高亮
;;(use-package highlight-symbol
;;  :init (highlight-symbol-mode)
;;  :bind ("<f3>" . highlight-symbol))
;; 高亮转义
;;(use-package highlight-escape-sequences)

;; ------------------------------------
;; modeline

;; modeline 显示时间
(display-time-mode 1)
;; modeline 上时间24h时间格式
(setq display-time-24hr-format t)
;; modeline 显示日期、星期
(setq display-time-day-and-date t)
;; 在 Modeline 上显示列号
(column-number-mode t)
;; modeline 主题配置
(use-package doom-modeline
             :hook (after-init . doom-modeline-mode))

;; ------------------------------------
;; tab栏

(use-package centaur-tabs
             :demand
             :config
             ;; 圆角主题
             (setq centaur-tabs-style "bar")
             ;; 高度
             (setq centaur-tabs-height 25)
             ;; 使用标签图标
             (setq centaur-tabs-set-icons t)
             ;; 显示新建标签按钮
             (setq centaur-tabs-show-new-tab-button t)
             ;; 显示修改标记
             (setq centaur-tabs-set-modified-marker t)
             ;; 显示导航按钮
             (setq centaur-tabs-show-navigation-buttons t)
             ;; 选中标签显示彩条的位置
             (setq centaur-tabs-set-bar 'under)
             ;; 是否显示标签计数
             ;; (setq centaur-tabs-show-count nil)
             ;; 选中标签的标记线颜色
             (set-face-attribute 'centaur-tabs-active-bar-face nil :background "#ff92df")
             ;; 标签最大长度
             ;; (setq centaur-tabs-label-fixed-length 15)
             ;; (setq centaur-tabs-gray-out-icons 'buffer)
             ;; 图标无色
             (setq centaur-tabs-plain-icons t)
             ;; (setq x-underline-at-descent-line t)
             ;; (setq centaur-tabs-left-edge-margin nil)
             ;; 标签关闭按钮图标
             (setq centaur-tabs-close-button "󰅙")
             (centaur-tabs-change-fonts "IntoneMono NFM" 110)
             (centaur-tabs-mode t)
             :bind
             ;; `ctrl+pgup\pgdown'切换标签
             ("C-<prior>" . centaur-tabs-backward)
             ("C-<next>" . centaur-tabs-forward))

;; ------------------------------------
;; 主题与配色
;; 德古拉主题
(use-package dracula-theme
             :init (load-theme 'dracula t))
;; 对括号识别进行配置，此配置需要在德古拉主题之后，因为主题会改变括号加粗，导致行抖动
;; 默认情况下，在显示匹配的括号之前会有一个小的延迟，设置为0
(setq show-paren-delay 0)
(show-paren-mode 1)
;; 需要paren才能配置
(require 'paren)
;; ;; 前景色
;; (set-face-foreground 'show-paren-match "red")
;; 不对括号匹配加粗
(set-face-bold 'show-paren-match nil)
;; ;; 背景色
;; (set-face-background 'show-paren-match "white")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(provide 'init-ui)
;;; init-ui.el ends here

;;; early-init.el --- Emacs 27 introduces early-init.el, which runs before init.el

;;; Commentary:
;;
;; Runs before package and UI initializetion happens.
;; Emacs 27 introduces early-init.el, which is run before init.el,
;; before package and UI initialization happens.
;;

;;; Code:

;; 为了加快启动速度，
;; 在 Emacs after-init-hook 之后，请不要忘记将其重置为默认值
;; 否则可能会导致冻结。
;; 在启动过程中进一步推迟垃圾收集
(setq gc-cons-threshold most-positive-fixnum)

;; 防止 gccemacs (native-comp) 用户不需要的运行时编译；
;; 软件包在安装时提前编译，设置文件在安装 gccemacs 时编译。
(setq native-comp-deferred-compilation nil)
(setq native-comp-jit-compilation nil)

;; 包初始化会在加载“user-init-file”之前、“early-init-file”之后自动发生。
;; 需要处理包的初始化，所以必须阻止 Emacs 提前做这件事
(setq package-enable-at-startup nil)

;; `use-package' 自 29 起内置。
;; 必须在加载“use-package”之前设置它。
(setq use-package-enable-imenu-support t)

;; 在非交互式会话中，优先考虑非字节编译的源文件，以防止使用过时的字节代码。
;; 否则，跳过对每个 *.elc 文件的 mtime 检查可以节省一点 IO 时间。
(setq load-prefer-newer noninteractive)

;;明确设置首选编码系统以避免来自 emacs 的烦人提示（尤其是在 Windows 上）
(prefer-coding-system 'utf-8)

;; 禁止调整框架大小
(setq frame-inhibit-implied-resize t)

;; 在这里更快地禁用它们（在它们初始化之前）
;; 提前处理GUI页面部分设置，以加快启动
;; fboundp 检查是否定义了，如果定义了则返回true
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
(when (featurep 'ns)
  (push '(ns-transparent-titlebar . t) default-frame-alist))
(setq-default mode-line-format nil)

;; (add-hook 'emacs-startup-hook 
;;           (lambda ()
;;             (setq gc-cons-threshold 800000)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(provide 'early-init)

;;; early-init.el ends here
;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; END:

;;; init-features.el --- Features Configuration.	-*- lexical-binding: t no-byte-compile: t -*-
;; evi1_f4iry self use
;;; Commentary:
;;
;; Define constants.
;;
;;; Code:

;;; 原生配置项
;; 从 Emacs 29 开始，“yes-or-no-p”将使用“y-or-n-p”
(setopt use-short-answers t)
;; 在关闭 Emacs 前询问是否确认关闭，防止误触
(setq confirm-kill-emacs #'y-or-n-p)
;; 自动补全括号
(electric-pair-mode t)
;; 当另一程序修改了文件时，让 Emacs 及时刷新 Buffer
(global-auto-revert-mode t) 
;; 选中文本后输入文本会替换文本
(delete-selection-mode t)
;; 关闭文件自动备份
(setq make-backup-files nil)
;; 编程模式下，可以折叠代码块
(add-hook 'prog-mode-hook #'hs-minor-mode)
;; （可选）打开 Buffer 历史记录保存
;; (savehist-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(provide 'init-features)
;;; init-features.el ends here

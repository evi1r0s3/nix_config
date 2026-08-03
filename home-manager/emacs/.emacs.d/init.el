;;; init.el --- the entry of emacs config -*- lexical-binding: t -*-
;; Author: evi1_f4iry
;; Github: https://github.com/evi1r0s3
;;; Commentary:
;;
;;; Code:

(unless (>= emacs-major-version 30)
  (error "ONLY EMACS v30+ IS SUPPORTED! 只支持EMACS v30+，因为在配置插件时使用了30的vc关键字"))

;; 当发生错误时取消注释此行用于debug
;; 效果与 `emacs --init-debug' 一样
;; (setq debug-on-error t)

;; 在启动过程中进一步推迟垃圾收集
(setq gc-cons-threshold most-positive-fixnum)

;; 防止启动时，没有样式的 `modeline' 闪烁
(setq-default mode-line-format nil)

;; 不要将不区分大小写的传递给 `auto-mode-alist'
(setq auto-mode-case-fold nil)

;; 启动时禁止文件处理程序操作
;; 因为每次调用 `require' 和 `load' 时都会查询 `file-name-handler-alist'。
(unless (or (daemonp) noninteractive init-file-debug)
  (let ((old-value file-name-handler-alist))
    (setq file-name-handler-alist nil)
    (set-default-toplevel-value 'file-name-handler-alist file-name-handler-alist)
    (add-hook 'emacs-startup-hook
              (lambda ()
                "Recover file name handlers."
                (setq file-name-handler-alist
                      (delete-dups (append file-name-handler-alist old-value))))
              101)))

;; 定义常量系统判断
(defconst sys/mac (eq system-type 'darwin))
(defconst sys/win (memq system-type '(ms-dos windows-nt cygwin)))

;; 优化：将 `lisp' 和 `site-lisp' 强制放在头部，以减少启动时间。
(defun update-load-path (&rest _)
  "Update `load-path'."
  (dolist (dir '("site-lisp" "lisp"))
    (push (expand-file-name dir user-emacs-directory) load-path)))

(defun add-subdirs-to-load-path (&rest _)
  "Add subdirectories to `load-path'.
  Don't put large files in `site-lisp' directory, e.g. EAF.
  Otherwise the startup will be very slow."
  (let ((default-directory (expand-file-name "site-lisp" user-emacs-directory)))
    (normal-top-level-add-subdirs-to-load-path)))
;; hook 到 `package-initalize' 之后
(advice-add #'package-initialize :after #'update-load-path)
(advice-add #'package-initialize :after #'add-subdirs-to-load-path)
;; 挂载目录
(update-load-path)

(setq-default major-mode 'text-mode)
(add-hook 'text-mode-hook 'flyspell-mode)
(add-hook 'emacs-lisp-mode-hook 'eldoc-mode)

;; 前置
;; 自定义函数
(require 'init-funcs)
;; 字体配置
(require 'init-font)

;; 包管理
(require 'init-package)

;; UI
(require 'init-ui)
;; feature
(require 'init-features)
;; LSP
(require 'init-prog)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(provide 'init)

;;; init.el ends here
;;; Local Variables:
;; coding: utf-8
;; byte-compile-warnings: (not unresolved obsolete)
;; End:

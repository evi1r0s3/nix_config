;;; init-package.el --- the package config -*- lexical-binding: t -*-
;; Author: evi1_f4iry
;; Github: https://github.com/evi1r0s3
;;; Commentary:
;;
;;; Code:

;; 为emacs在图形界面中的点点点所产生的配置使用单独的文件
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;; HACK: DO NOT save `package-selected-packages' to `custom-file'
;; @see https://github.com/jwiegley/use-package/issues/383#issuecomment-247801751
(defun my-package--save-selected-packages (&optional value)
  "Set `package-selected-packages' to VALUE but don't save to option `custom-file'."
  (when value
    (setq package-selected-packages value))
  (unless after-init-time
    (add-hook 'after-init-hook #'my-package--save-selected-packages)))
(advice-add 'package--save-selected-packages :override #'my-package--save-selected-packages)

;; 设置包源换成国内源
(setq package-archives '(("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
      ("gnu" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
      ("org" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/org/")))

;; 初始化 package
(unless (bound-and-true-p package--initialized) ; To avoid warnings in 27
  (setq package-enable-at-startup nil)          ; To prevent initializing twice
  (package-initialize))

;; 更新内置包
(setq package-install-upgrade-built-in t)

;; 设定 `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; 加载`use-package'前设置
;; 全部确认安装
(setq use-package-always-ensure t)
;; 一概延迟加载
(setq use-package-always-defer t)
;; 禁用捕捉包错误报告
(setq use-package-expand-minimally t)
;; 使用imenu定位到use-package配置块
(setq use-package-enable-imenu-support t)

;; 启用`use-package' diminish 关键字功能
(use-package diminish :ensure t)

;; 更新 GNU ELPA 的 GPG 密钥环
(use-package gnu-elpa-keyring-update)
;; 包升级
(unless (fboundp 'package-upgrade-all)
  (use-package auto-package-update
    :init
    (setq auto-package-update-delete-old-versions t
          auto-package-update-hide-results t)
    (defalias 'package-upgrade-all #'auto-package-update-now)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(provide 'init-package)

;;; init-package.el ends here
;;; Local Variables:
;; coding: utf-8
;; byte-compile-warnings: (not unresolved obsolete)
;; End:

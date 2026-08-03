;;; init-prog.el --- the LSP & prog env config -*- lexical-binding: t -*-
;; Author: evi1_f4iry
;; Github: https://github.com/evi1r0s3
;;; Commentary:
;;
;;; Code:

;; Language Server (eglot - emacs.v29 起内置)
(use-package eglot
             :bind ("C-c e f" . eglot-format)
             :init
             (advice-add 'eglot-code-action-organize-imports :before #'eglot-format-buffer)
             (add-hook 'eglot-managed-mode-hook (lambda () (add-hook 'before-save-hook #'eglot-format-buffer)))
             (add-hook 'prog-mode-hook
                       (lambda () (unless (member major-mode '(emacs-lisp-mode))
                                    (eglot-ensure)))))

(use-package treesit-auto
             :hook (after-init . global-treesit-auto-mode)
             :custom (treesit-auto-install 'prompt)
             :config (treesit-auto-add-to-auto-mode-alist 'all))

;; direnv
(use-package direnv
             :config
             (direnv-mode))

(use-package company
  ;; 等价于 (add-hook 'after-init-hook #'global-company-mode)
  :hook (after-init . global-company-mode)
  :config
  ;; setq 可以像这样连着设置多个变量的值
  (setq company-tooltip-align-annotations t ; 注释贴右侧对齐
        company-tooltip-limit 20            ; 菜单里可选项数量
        company-show-numbers t              ; 显示编号（然后可以用 M-数字 快速选定某一项）
        company-idle-delay .1               ; 延时多少秒后弹出
        company-minimum-prefix-length 1     ; 至少几个字符后开始补全
        ))

(use-package copilot
  :vc (:url "https://github.com/copilot-emacs/copilot.el"
            :rev :newest
            :branch "main")
  :config
  (define-key copilot-completion-map (kbd "<tab>") 'copilot-accept-completion))

(use-package copilot-chat)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(provide 'init-prog)

;;; init-prog.el ends here
;;; Local Variables:
;; coding: utf-8
;; byte-compile-warnings: (not unresolved obsolete)
;; End:

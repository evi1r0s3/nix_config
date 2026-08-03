;;; init-font.el --- the entry of emacs config -*- lexical-binding: t -*-
;; Author: evi1_f4iry
;; Github: https://github.com/evi1r0s3
;;; Commentary:
;;
;;; Code:

;;(set-face-attribute 'default nil :font "Maple Mono SC NF" :height 110)
;;(set-face-attribute 'default nil :font "Maple Mono SC NF 11")

(set-face-attribute 'default nil :font "Maple Mono NF CN 11")

(dolist (charset '(han kana symbol cjk-misc bopomofo))
  (set-fontset-font t charset "Maple Mono NF CN 11"))
;; 以下这几个方法还是会在一些情况发生问题，所以，最后还是得用一个全等的字体，哎
(when nil
;; 方法四
;; 我的方法，同样设置系数缩放，但不调整行距，而是通过修改行号字体预先渲染单行的高度，
;; 从而保证在中英混合字体时不会因为先输入英文再输入中文而发生行高变化，导致抖动
;; 缺点：
;; 1.如果中英字体差距大，仍然会看上去不协调美观，但是这是已知方法中的通病
;; 优点：
;; 1.调整行号更美观一些，而且不会导致由于调整行高行距导致的其他一系列问题，比如：在文档
;; 最后一行只输入英文，然后直接回车到下一行。如果是调整行距的方法则会发现行高发生变化
;; 这还不是我最满意的解决方案
;; 因为我始终认为，调整cjk字符横向间距才是最合理的解决方案，当前只是临时解决方案。
;; 字符间距这部分取决于上游代码，我始终认为这是可以被修改的代码，不过暂时没精力做贡献，
;; 留下这个有瑕疵的解决方案，提醒自己有空去贡献点力量
;; -- evi1_f4iry
;;
;; 函数定义：
;; (font/test-mono ("英文字体" "中文字体" 英文字号 中文缩放比例 "行号字体")
;;
;; 行号字体是可选的，如果不定义则会自动使用英文字体，选择喜欢的字体就好
;; 但是行号不要用中文字体，渲染会变宽
;;
;; 应在emacs正常启动后在 *scratch* 多次中执行这个函数
;; 通过输出的样例，找到喜欢的英文字体和中文字体中的合适缩放比例
;;
;; 执行的例子
;; (font/test-mono "ComicShannsMono Nerd Font Mono" "Microsoft Yahei" 26 1.1 "IntoneMono NFM")
;; 执行完，如果输出的样例满意，则可以直接复制输出的最后一行中返回的函数，到配置文件中去
;; 这样就会在init后保持这个配置

(defun font/test-mono (EN-FONT CN-FONT FONT-SIZE CN-RESCALE &optional LN-FONT)
  (let* ( (line-font (or LN-FONT EN-FONT))
         (en-font (font-spec :name EN-FONT :size FONT-SIZE))
         (cn-font (font-spec :name CN-FONT)) )

    (set-face-attribute 'default nil :font en-font)

    (dolist (charset '(han kana symbol cjk-misc bopomofo))
      (set-fontset-font t charset cn-font))

    (setq face-font-rescale-alist `((,CN-FONT . ,CN-RESCALE)))
    (set-face-attribute 'line-number nil :font (format "%s:pixelsize=1" LN-FONT))

    (let* ((en-height (line-pixel-height)))

      (set-face-attribute 'default nil :font (format "%s:pixelsize=%d" CN-FONT (aref (font-info CN-FONT) 2)))
      (set-face-attribute 'line-number nil :font (format "%s:pixelsize=1" LN-FONT))

      (let* ((cn-height (line-pixel-height))
             (max-height (max cn-height en-height))
             (pixel-size 10))
        (set-face-attribute 'default nil :font en-font)
        (set-face-attribute 'line-number nil :font (format "%s:pixelsize=%d" line-font pixel-size))

        (while (< (line-pixel-height) max-height)
               (set-face-attribute 'line-number nil :font (format "%s:pixelsize=%d" line-font pixel-size))
               (setq pixel-size (+ 2 pixel-size))
               )
        (set-face-attribute 'line-number nil :font (format "%s:pixelsize=%d" line-font (- pixel-size 4)))
        (insert "\n
                |aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa|
                |你你你你你你你你你你你你你你你你你你你你|
                |,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,|
                |。。。。。。。。。。。。。。。。。。。。|
                |1111111111111111111111111111111111111111|
                |東東東東東東東東東東東東東東東東東東東東|
                |ここここここここここここここここここここ|
                |ｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺ|
                |까까까까까까까까까까까까까까까까까까까까|
                |abcdefghijklmnopqrstABCDEFGHIJKLMNOPQRST|
                |uvxwyzUVWXYZ1234567890                  |
                |Il1iL10oOq9g!@#$%^&*()-=_+,./<>?\;'\":[]|
                ")

        (insert "\n检查上面每行是否对齐，英文行长则应将中文缩放比例调整到1.0以上，中文行长则应调整到1.0以下")
                
        (insert "\n执行以下语句检查是否等宽和中英混行抖动，无问题后将此句放在你的配置文件中，这样每次启动就是配置好的字体了。
                                                                                   --evi1_f4iry \n")
        (insert "(add-hook 'after-init-hook (lambda () ")                
        (insert (prin1-to-string `(font/set-mono,EN-FONT ,CN-FONT ,FONT-SIZE ,CN-RESCALE ,line-font ,(- pixel-size 4))))
        (insert "))")
        )
      )
    )
  )

(defun font/set-mono (EN-FONT CN-FONT FONT-SIZE CN-RESCALE LN-FONT LN-FONT-SIZE)
  (let* ((en-font (font-spec :name EN-FONT :size FONT-SIZE))
         (cn-font (font-spec :name CN-FONT)) )

    (set-face-attribute 'default nil :font en-font)

    (dolist (charset '(han kana symbol cjk-misc bopomofo))
      (set-fontset-font t charset cn-font))

    (setq face-font-rescale-alist `((,CN-FONT . ,CN-RESCALE)))
    (set-face-attribute 'line-number nil :font (format "%s:pixelsize=%d" LN-FONT LN-FONT-SIZE))
    )
  )

;; font/test-mono 测试出来的结果放在这里就好
(add-hook 'after-init-hook (lambda () (font/set-mono "ComicShannsMono Nerd Font Mono" "Microsoft Yahei" 26 1.1 "IntoneMono NFM" 28)))
)


;; 以下是其他常见的方法，只是为了对比放在这里
(when nil
  ;; 方法一，使用等宽等高字体，如Iosevka，更纱黑等
  ;; 缺点：
  ;; 1.字体不好看
  ;; 2.不能自由选择字体
  (defun font/mono-font-by-font (FONT-NAME FONT-SIZE)
    (if (find-font (font-spec :name FONT-NAME))
      (set-face-attribute 'default nil :font (font-spec :name FONT-NAME :size FONT-SIZE))
      (error (format "找不到%s字体" FONT-NAME))))
  (font/mono-font-by-font "NotoSansM NFM" 24)
  )

(when nil
  ;; 方法二，按比例配置中英文字体
  ;; 缺点：
  ;; 1.需要修改上下行距，否则输入英文后再输入中文，行高度会变化视觉上会有抖动，修改后显得不紧凑
  ;; 2.中英文高度差距较大，并不美观
  ;; 3.不同字体组合，放大系数和行距都需要根据字体调整
  (defun font/mono-font-by-scale (FONT-NAME CN-FONT-NAME &optional INITIAL-SIZE CN-FONT-RESCALE-RATIO)
    (let* ((size (or INITIAL-SIZE 14))
           (ratio (or CN-FONT-RESCALE-RATIO 0.0))
           (main (font-spec :name FONT-NAME :size size))
           (cn (font-spec :name CN-FONT-NAME)))
      (set-face-attribute 'default nil :font main)
      (dolist (charset '(kana han symbol cjk-misc bopomofo))
        (set-fontset-font t charset cn))
      (setq face-font-rescale-alist (if (/= ratio 0.0) `((,CN-FONT-NAME . ,ratio)) nil))))
  (font/mono-font-by-scale "IntoneMono NFM" "Microsoft Yahei" 24 1.25)
  ;; 设置上下行距，从而保持中英文混合的行不会抖动，根据字体调节一下
  (setq default-text-properties '(line-spacing 0.15 line-height 1.15))
  )

(when nil
  ;; 方法三，使用已知配对效果好的中英文字体组合
  ;; 缺点：
  ;; 1.有些字体组合需要修改行距，修改行距会看上去不紧凑
  ;; 2.没有特别满意的字体组合，ubuntu+yahei虽然还行，但一股子ubuntu味
  (defun font/mono-font-without-scale (FONT-NAME CN-FONT-NAME FONT-SIZE)
    (set-face-attribute 'default nil :font (font-spec :name FONT-NAME :size FONT-SIZE))
    (dolist (charset '(kana han symbol cjk-misc bopomofo))
      (set-fontset-font t charset (font-spec :name CN-FONT-NAME))))
  (font/mono-font-without-scale "UbuntuMono Nerd Font Mono" "Microsoft Yahei" 24)
  ;; 设置上下行距，从而保持中英文混合的行不会抖动，根据字体调节一下
  (setq default-text-properties '(line-spacing 0.11 line-height 1.225))

  )



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(provide 'init-font)

;;; init-font.el ends here
;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; END:

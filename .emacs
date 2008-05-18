(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(fill-column 80)
 '(show-paren-mode t)
 '(transient-mark-mode t))

;set load path
(setq load-path (cons "~/.emacs.d/" load-path))

;(set-default-font "-outline-Terminus-medium-r-normal-normal-16-120-96-96-c-*-iso8859-1")
(set-default-font "-*-terminus-medium-r-*-*-14-*-*-*-*-*-*-*")

;;compilation w/ ant
(require 'compile)
(setq compilation-error-regexp-alist
  (list
     ;; java
     '("\\(\\w+\\.java\\):\\([0-9]+\\):" 1 2)
     '("(\\(\\w+\\.java\\):\\([0-9]+\\))" 1 2))
  )

(add-hook 'java-mode-hook '(lambda () (setq compile-command "ant -find")))
(add-hook 'java-mode-hook '(lambda () (c-toggle-hungry-state '1)))

(setq compilation-scroll-output 't)

;;display
(setq inhibit-splash-screen 't)
(tool-bar-mode 0)
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )

;;fixes for annoyances
(fset 'yes-or-no-p 'y-or-n-p)

;;custom modes
(defun linux-c-mode ()
  "C mode with adjusted defaults for use with the Linux kernel."
  (interactive)
  (c-mode)
  (c-set-style "K&R")
  (setq tab-width 8)
  (setq indent-tabs-mode t)
  (setq c-basic-offset 8))

;;c defaults
(defun default-c-mode ()
  "Generic C mode settings"
  (c-set-style "K&R")
  (setq tab-width 8)
  (setq indent-tabs-mode nil)
  (setq c-basic-offset 2)
  (setq kill-whole-line t))
(add-hook 'c-mode-hook 'default-c-mode)

;lua-mode
(setq auto-mode-alist (cons '("\\.lua$" . lua-mode) auto-mode-alist))
(autoload 'lua-mode "lua-mode" "Lua editing mode." t)
(add-hook 'lua-mode-hook 'turn-on-font-lock)
(add-hook 'lua-mode-hook 'hs-minor-mode)
(add-hook 'lua-mode-hook '(lambda () (setq lua-indent-level 2)))

;;ruby
;(load-file "~/ruby-mode.el")
;(setq auto-mode-alist  (cons '("\\.rb$" . ruby-mode) auto-mode-alist))
;(add-hook 'ruby-mode-hook '(lambda () (setq compile-command "rake")))

;;key bindings
(global-set-key [f4] 'undo)

;;configure mmm-mode
;(require 'mmm-auto)
;(setq mmm-global-mode 'maybe)

;(mmm-add-group
; 'html-ruby
; '((eruby-line
;    :submode ruby-mode
;    :front "^%"
;    :back "$")
;   (eruby-block
;    :submode ruby-mode
;    :front "<%[#=]?"
;    :back "%>"
;    :insert ((?b erb-code       nil @ "<%"  @ " " _ " " @ "%>" @)
;             (?c erb-comment    nil @ "<%#" @ " " _ " " @ "%>" @)
;             (?e erb-expression nil @ "<%=" @ " " _ " " @ "%>" @)))))

;(add-hook 'html-mode-hook
;	  (lambda ()
;	    (local-set-key (kbd "<f8>") 'mmm-parse-buffer)))

;(mmm-add-mode-ext-class 'html-mode "\\.rhtml$" 'html-ruby)

;(setq mmm-submode-decoration-level '0)
;(setq mmm-mode-prefix-key [?\C-c ?c])

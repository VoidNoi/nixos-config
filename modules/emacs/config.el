(add-to-list 'default-frame-alist '(undecorated . t))
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(setq standard-indent 2)

;;(set-frame-parameter nil 'alpha-background 95) ; For current frame
;;(add-to-list 'default-frame-alist '(alpha-background . 95))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-vsplit-window-right t)
  (setq evil-split-window-below t)
  (evil-mode))
(use-package evil-collection
  :after evil
  :config
  (setq evil-collection-mode-list '(dashboard dired ibuffer))
  (evil-collection-init)
)

(use-package 'multiple-cursors
  :ensure t
)

(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

(use-package 'prettier-js
  :after js2-mode
  :init
  (add-hook 'js2-mode-hook 'prettier-js-mode)
  (add-hook 'web-mode-hook 'prettier-js-mode)
  (add-hook 'css-mode-hook 'prettier-js-mode)
)

; Enable vertico
(use-package vertico
  :init
  (vertico-mode)
  :custom
  (vertico-sort-function 'vertico-sort-history-alpha)
)

(use-package savehist
  :init
  (savehist-mode)
)

(use-package orderless
    :custom
    (completion-styles '(orderless basic))
    (completion-category-defaults nil)
    (completion-category-overrides
     '((file (styles partial-completion))))
)

(use-package marginalia
    :init
    (marginalia-mode)
)

(defun delete-window-or-kill-emacs ()
  "Delete the selected frame.  If the last one, kill Emacs."
  (interactive)
  (condition-case nil (delete-window) (error (save-buffers-kill-terminal)))
)

; Set keybinds
(evil-set-leader 'motion (kbd "SPC"))

(evil-define-key 'normal 'global (kbd "<leader>ws") 'split-window-vertically)
(evil-define-key 'normal 'global (kbd "<leader>wv") 'split-window-horizontally)
(evil-define-key 'normal 'global (kbd "<leader>ww") 'other-window)
(evil-define-key 'normal 'global (kbd "<leader>bu") 'ibuffer)
(evil-define-key 'normal 'global (kbd "<leader>wq") 'delete-window-or-kill-emacs)
(evil-define-key 'normal 'global (kbd "<leader>f") 'find-file)
(evil-define-key 'normal 'global (kbd "<leader>,") 'previous-buffer)
(evil-define-key 'normal 'global (kbd "<leader>.") 'next-buffer)
(evil-define-key 'normal 'global (kbd "<leader><left>") 'evil-window-left)
(evil-define-key 'normal 'global (kbd "<leader><right>") 'evil-window-right)
(evil-define-key 'normal 'global (kbd "<leader>op") 'neotree-toggle)
(evil-define-key 'normal 'global (kbd "<leader>bb") 'bookmark-jump)

(load-theme 'catppuccin t)

(use-package 'neotree
  :init
  (setq neo-window-fixed-size nil)
  (setq neo-window-width 30)
  )
(setq neo-theme (if (display-graphic-p) 'icons 'arrow))
(setq neo-autorefresh t)

(defun set-init-frame ()
  (use-package nerd-icons)
  (use-package dashboard
  	:ensure t
  	:init
  	(dashboard-setup-startup-hook)
  	:config
        
  	(setq dashboard-set-file-icons t)     ; display icons on both GUI and terminal
  	(setq dashboard-icon-type 'nerd-icons)  ; use `nerd-icons' package
      
  	(setq dashboard-center-content t)
  	(setq dashboard-vertically-center-content t)
  	(setq dashboard-items '((recents   . 5)
  				(bookmarks . 5)
        			  	))
      
  	(setq dashboard-startupify-list '(dashboard-insert-banner
                                  	  dashboard-insert-newline
                                            dashboard-insert-banner-title
                                            dashboard-insert-newline
                                            dashboard-insert-items
        				 	 ))
   	(setq dashboard-banner-logo-title "We'll protect this planet. You and me.")
  )
)

(add-hook 'server-after-make-frame-hook 'set-init-frame)

(setq initial-buffer-choice (lambda () (get-buffer-create "*dashboard*")))

; Changes the directory backup files are saved to
(setq backup-directory-alist `(("." . "~/.saves")))
(setq backup-by-copying t)
(setq delete-old-versions t
  kept-new-versions 6
  kept-old-versions 2
  version-control t
)
;; Auto-refresh dired on file change
(add-hook 'dired-mode-hook 'auto-revert-mode)

(add-to-list 'default-frame-alist '(undecorated . t))
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(setq-default indent-tabs-mode nil)
(setq standard-indent 2)

(disable-theme 'misterioso) ;; Disabling this theme because it interferes with the set theme

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
(use-package company
  :ensure t
  :init
  (add-hook 'after-init-hook 'global-company-mode)
  (add-hook 'after-init-hook 'company-tng-mode))

(use-package 'prettier-js
  :after js2-mode
  :init
  (add-hook 'js2-mode-hook 'prettier-js-mode)
  (add-hook 'web-mode-hook 'prettier-js-mode)
  (add-hook 'css-mode-hook 'prettier-js-mode)
)

;; Enable vertico
(use-package vertico
  :init
  (vertico-mode)
  :custom
  (vertico-sort-function 'vertico-sort-history-alpha)
  )
;; set up arduino-cli | Requires arduino-cli and setting arduino-cli-default-fqbn for each project with add-dir-local-variable for arduino-mode
(use-package arduino-cli-mode
  :ensure t
  :hook arduino-mode
  :custom
  (arduino-cli-default-port "/dev/ttyACM0")
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

;; Set keybinds
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
(evil-define-key 'normal 'global (kbd "<leader><down>") 'evil-window-down)
(evil-define-key 'normal 'global (kbd "<leader><up>") 'evil-window-up)
(evil-define-key 'normal 'global (kbd "<leader>op") 'neotree-toggle)
(evil-define-key 'normal 'global (kbd "<leader>bb") 'bookmark-jump)

(use-package evil-mc 
  :ensure t
  :config
  (global-evil-mc-mode 1)
  )

(evil-define-key 'normal 'global (kbd "C-c C-<") 'evil-mc-make-all-cursors)

(load-theme 'catppuccin t)

(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook)
  :custom ;; Configuration needs to be on :custom or the dashboard won't display properly
  (dashboard-items '((recents   . 5)
  		     (bookmarks . 5)
		     (agenda)
        	     ))
  (dashboard-icon-type 'nerd-icons)
  (dashboard-set-heading-icons t)
  (dashboard-set-file-icons t)     ;; display icons on both GUI and terminal
  
  (dashboard-banner-logo-title "We'll protect this planet. You and me.")
  (dashboard-set-init-info t)
  (dashboard-vertically-center-content t)
  (dashboard-display-icons-p t)  ;; This makes sure the icons are displayed before the dashboard loads
  (dashboard-center-content t)
  (dashboard-week-agenda t)
  (dashboard-startupify-list '(dashboard-insert-banner
                                    dashboard-insert-newline
                                    dashboard-insert-banner-title
                                    dashboard-insert-newline
                                    dashboard-insert-items
         			    ))	
  )
(setq initial-buffer-choice (lambda () (get-buffer-create "*dashboard*")))

(add-hook 'server-after-make-frame-hook 'revert-buffer) ;; Fixes agenda TODO not displaying properly in the dashboard on first frame

;; Changes the directory backup files are saved to
(setq backup-directory-alist `(("." . "~/.saves")))
(setq backup-by-copying t)
(setq delete-old-versions t
  kept-new-versions 6
  kept-old-versions 2
  version-control t
  )
;; Auto-refresh dired on file change
(add-hook 'dired-mode-hook 'auto-revert-mode)

(use-package org)

(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c C-l") 'org-insert-link)

(setq org-agenda-files '("~/org"))
(setq org-adapt-indentation t)

(add-hook 'org-mode-hook 'visual-line-mode)

(setq org-src-fontify-natively t)
      
(add-to-list 'org-src-block-faces (list "" (list :foreground (catppuccin-get-color 'green))))

(defun ctp/text-org-blocks ()
  (face-remap-add-relative 'org-block (list :foreground (catppuccin-get-color 'text))))
(add-hook 'org-mode-hook 'ctp/text-org-blocks)

(setq org-hide-emphasis-markers t)
(font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))
(use-package org-bullets
    :config
    (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

(defun org-todo-if-needed (state)
  "Change header state to STATE unless the current item is in STATE already."
  (unless (string-equal (org-get-todo-state) state)
    (org-todo state)))

(defun ct/org-summary-todo-cookie (n-done n-not-done)
  "Switch header state to DONE when all subentries are DONE, to TODO when none are DONE, and to DOING otherwise"
  (let (org-log-done org-log-states)   ;; turn off logging
    (org-todo-if-needed (cond ((= n-done 0)
                               "TODO")
                              ((= n-not-done 0)
                               "DONE")
                              (t
                               "DOING")))))

(add-hook 'org-after-todo-statistics-hook #'ct/org-summary-todo-cookie)

(defun ct/org-summary-checkbox-cookie ()
  "Switch header state to DONE when all checkboxes are ticked, to TODO when none are ticked, and to DOING otherwise"
  (let (beg end)
    (unless (not (org-get-todo-state))
      (save-excursion
        (org-back-to-heading t)
        (setq beg (point))
        (end-of-line)
        (setq end (point))
        (goto-char beg)
        ;; Regex group 1: %-based cookie
        ;; Regex group 2 and 3: x/y cookie
        (if (re-search-forward "\\[\\([0-9]*%\\)\\]\\|\\[\\([0-9]*\\)/\\([0-9]*\\)\\]"
                               end t)
            (if (match-end 1)
                ;; [xx%] cookie support
                (cond ((equal (match-string 1) "100%")
                       (org-todo-if-needed "DONE"))
                      ((equal (match-string 1) "0%")
                       (org-todo-if-needed "TODO"))
                      (t
                       (org-todo-if-needed "DOING")))
              ;; [x/y] cookie support
              (if (> (match-end 2) (match-beginning 2)) ;; = if not empty
                  (cond ((equal (match-string 2) (match-string 3))
                         (org-todo-if-needed "DONE"))
                        ((or (equal (string-trim (match-string 2)) "")
                             (equal (match-string 2) "0"))
                         (org-todo-if-needed "TODO"))
                        (t
                         (org-todo-if-needed "DOING")))
                (org-todo-if-needed "DOING"))))))))
(add-hook 'org-checkbox-statistics-hook #'ct/org-summary-checkbox-cookie)

(use-package yasnippet
  :config
  (setq yas-snippet-dirs '("~/snippets"))
  (yas-global-mode 1)
  )

(defun my/capitalize-first-char (&optional string)
  "Capitalize only the first character of the input STRING."
  (when (and string (> (length string) 0))
    (let ((first-char (substring string nil 1))
          (rest-str   (substring string 1)))
      (concat (capitalize first-char) rest-str))))

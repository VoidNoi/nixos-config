(let (;; temporarily increase `gc-cons-threshold' when loading to speed up startup.
      (gc-cons-threshold most-positive-fixnum)
      ;; Empty to avoid analyzing files when loading remote files.
      (file-name-handler-alist nil))

    ;; Emacs configuration file content is written below.
;; Start scratch buffer in fundamental mode for optimization
(setq initial-major-mode 'fundamental-mode)

(setq frame-inhibit-implied-resize t)

(add-to-list 'default-frame-alist '(undecorated . t))
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(setq-default indent-tabs-mode nil)
(setq standard-indent 2)

(setq org-archive-location "~/org/archive.org_archive::")
(setq org-image-actual-width nil)
(setq org-startup-folded 'nofold)

(add-to-list 'default-frame-alist '(font . "FiraCode Nerd Font mono 10"))

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  )

(disable-theme 'misterioso) ;; Disabling this theme because it interferes with the set theme

(defadvice org-babel-execute-src-block (around load-language nil activate)
  "Load language if needed"
  (let ((language (org-element-property :language (org-element-at-point))))
    (unless (cdr (assoc (intern language) org-babel-load-languages))
      (add-to-list 'org-babel-load-languages (cons (intern language) t))
      (org-babel-do-load-languages 'org-babel-load-languages org-babel-load-languages))
    ad-do-it))

;;(set-frame-parameter nil 'alpha-background 95) ; For current frame
;;(add-to-list 'default-frame-alist '(alpha-background . 95))

;; Pregenerate agenda buffer when emacs is idle for more than 2 seconds
(run-with-idle-timer 2 nil (lambda () (org-agenda-list) (delete-window)))

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

(use-package orderless
    :custom
    (completion-styles '(orderless partial-completion basic))
    (completion-category-defaults nil)
    (completion-category-overrides
     '((file (styles partial-completion))))
    )

(use-package corfu
  :after orderless
  :custom
  (corfu-cycle t)
  (corfu-auto t)
  (corfu-auto-prefix 2)
  (corfu-auto-delay 0.0)
  (corfu-quit-at-boundary 'separator)
  (corfu-echo-documentation 0.25)
  (corfu-preview-current 'insert)
  (corfu-preselect-first nil)
  :bind (:map corfu-map
              ("M-SPC" . corfu-insert-separator)
              ("RET"   . nil)
              ("TAB"   . corfu-next)
              ("S-TAB" . corfu-previous)
              ("S-<return>" . corfu-insert))
  :init
  (require 'bind-key)
  (global-corfu-mode)
  (corfu-history-mode)
  :config
  (add-hook 'eshell-mode-hook
            (lambda() (setq-local corfu-quit-at-boundary t
                                  corfu-quit-no-match t
                                  corfu-auto nil)
              (corfu-mode))))

(use-package cape
  :bind ("C-c p" . cape-prefix-map) ;; Alternative keys: M-p, M-+, ...
  :init
  (require 'bind-key)
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-elisp-block)
)

(setq-local completion-at-point-functions
  (mapcar #'cape-company-to-capf
    (list #'company-arduino #'company-web)))

;; set up arduino-cli | Requires arduino-cli and setting arduino-cli-default-fqbn for each project with add-dir-local-variable for arduino-mode
(use-package arduino-cli-mode
  :ensure t
  :hook arduino-mode
  :custom
  (arduino-cli-default-port "/dev/ttyACM0")
  )

(use-package company-arduino
  :config
  (setq company-arduino-home "~/.arduino15/packages/arduino")
  (setq company-arduino-header "~/.arduino15/packages/arduino/hardware/avr/1.8.6/cores/arduino/Arduino.h")
  (setq company-arduino-includes-dirs '("~/.arduino15/packages/arduino/hardware/avr/1.8.6/cores/arduino/" "~/.arduino15/packages/arduino/tools/avr-gcc/7.3.0-atmel3.6.1-arduino7/include/" "~/.arduino15/packages/arduino/hardware/avr/1.8.6/libraries/" "~/Arduino/libraries/"))
  )

;; Enable vertico
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

(use-package marginalia
    :init
    (marginalia-mode)
    )

(defun delete-window-or-kill-emacs ()
  "Delete the selected frame.  If the last one, kill Emacs."
  (interactive)
  (condition-case nil (delete-window) (error (save-buffers-kill-terminal)))
  )

(defun my:org-agenda-day ()
   (interactive)
   (org-agenda nil "d"))

;; Set keybinds

(evil-define-key 'normal 'global
  (kbd "SPC ws") 'split-window-vertically
  (kbd "SPC wv") 'split-window-horizontally
  (kbd "SPC ww") 'other-window
  (kbd "SPC bu") 'ibuffer
  (kbd "SPC wq") 'delete-window-or-kill-emacs
  (kbd "SPC f") 'find-file
  (kbd "SPC ,") 'previous-buffer
  (kbd "SPC .") 'next-buffer
  (kbd "SPC <left>") 'evil-window-left
  (kbd "SPC <right>") 'evil-window-right
  (kbd "SPC <down>") 'evil-window-down
  (kbd "SPC <up>") 'evil-window-up
  (kbd "SPC op") 'neotree-toggle
  (kbd "SPC RET") 'bookmark-jump
  (kbd "SPC r") 'recentf
  (kbd "SPC oa") 'org-agenda
  (kbd "SPC od") 'my:org-agenda-day
  (kbd "SPC ot") 'org-todo-list
  (kbd "SPC ol") 'org-open-at-point
  (kbd "SPC gg") 'magit-status
  (kbd "SPC af") 'org-ql-find-in-agenda
  )
;; Set keybinds for arduino-cli
(evil-define-key 'normal arduino-cli-mode-map
  (kbd "SPC au") 'arduino-cli-compile-and-upload
  (kbd "SPC ac") 'arduino-cli-compile
  )

(use-package evil-mc 
  :ensure t
  :config
  (global-evil-mc-mode 1)
  )

(evil-define-key 'normal 'global (kbd "C-c C-<") 'evil-mc-make-all-cursors)
(evil-define-key 'normal 'global (kbd "C->") 'evil-mc-make-and-goto-next-match)
(evil-define-key 'normal 'global (kbd "C-<") 'evil-mc-make-and-goto-prev-match)

(load-theme 'catppuccin t)

(defcustom dashboard-set-widget-binding t
  "If non-nil show keybindings in shortmenu widgets."
  :type 'boolean
  :group 'dashboard)

(defcustom dashboard-shortmenu-functions
  `((recents   . recentf)
    (bookmarks . bookmark-jump)
    (agenda    . org-agenda))
  "Functions to me used by shortmenu widgets.
Possible values for list-type are: `recents', `bookmarks', `projects',
`agenda' ,`registers'."
  :type  '(alist :key-type symbol :value-type function)
  :group 'dashboard)

(defface dashboard-bindings-face
  '((t (:inherit font-lock-constant-face)))
  "Face used for shortmenu widgets bindings."
  :group 'dashboard)

(defun dashboard-insert-org-agenda-shortmenu (&rest _)
  "Insert `org-agenda' shortmenu widget."
  (let* ((fn (alist-get 'agenda dashboard-shortmenu-functions))
         (fn-keymap (format "\\[%s]" fn))
         (icon-name (alist-get 'agenda dashboard-heading-icons))
         (icon (nerd-icons-octicon icon-name :face 'dashboard-heading :height 1.4)))
    (if dashboard-display-icons-p
        (insert (string-pad icon 2)))
    (widget-create 'item
                   :tag (format "%-30s" "Open org-agenda")
                   :action (lambda (&rest _)
                             (call-interactively 
                              (alist-get 'agenda dashboard-shortmenu-functions)))
                   :mouse-face 'highlight
                   :button-face 'dashboard-heading
                   :button-prefix ""
                   :button-suffix ""
                   :format "%[%t%]")
    (if dashboard-set-widget-binding
        (insert (propertize (substitute-command-keys fn-keymap)
                            'face
                            'dashboard-bindings-face)))))

(defun dashboard-insert-bookmark-shortmenu (&rest _)
  "Insert bookmark shortmenu widget."
  (let* ((fn (alist-get 'bookmarks dashboard-shortmenu-functions))
         (fn-keymap (format "\\[%s]" fn))
         (icon-name (alist-get 'bookmarks dashboard-heading-icons))
         (icon (nerd-icons-octicon icon-name :face 'dashboard-heading :height 1.4)))
    (if dashboard-display-icons-p
        (insert (string-pad icon 2)))
    (widget-create 'item
                   :tag (format "%-30s" "Jump to bookmark")
                   :action (lambda (&rest _)
                             (call-interactively 
                              (alist-get 'bookmarks dashboard-shortmenu-functions)))
                   :mouse-face 'highlight
                   :button-face 'dashboard-heading
                   :button-prefix ""
                   :button-suffix ""
                   :format "%[%t%]")
    (if dashboard-set-widget-binding
        (insert (propertize (substitute-command-keys fn-keymap)
                            'face
                            'dashboard-bindings-face)))))

(defun dashboard-insert-recents-shortmenu (&rest _)
  "Insert recent files short menu widget."
  (let* ((fn (alist-get 'recents dashboard-shortmenu-functions))
         (fn-keymap (format "\\[%s]" fn))
         (icon-name (alist-get 'recents dashboard-heading-icons))
         (icon (nerd-icons-octicon icon-name :face 'dashboard-heading :height 1.4)))
    (if dashboard-display-icons-p
        (insert (string-pad icon 2)))
    (widget-create 'item
                   :tag (format "%-30s" "Recently opened files")
                   :action (lambda (&rest _)
                             (call-interactively 
                              (alist-get 'recents dashboard-shortmenu-functions)))
                   :mouse-face 'highlight
                   :button-face 'dashboard-heading
                   :button-prefix ""
                   :button-suffix ""
                   :format "%[%t%]")
    (if dashboard-set-widget-binding
        (insert (propertize (substitute-command-keys fn-keymap)
                            'face
                            'dashboard-bindings-face)))))

(use-package dashboard
  :ensure t
  :init
  (setq initial-buffer-choice (lambda () (get-buffer-create dashboard-buffer-name)))
  :config
  (dashboard-setup-startup-hook)
  :custom ;; Configuration needs to be on :custom or the dashboard won't display properly
  (dashboard-center-content t)
  (dashboard-vertically-center-content t)
  (dashboard-item-generators
   '((recents   . dashboard-insert-recents-shortmenu)
     (bookmarks . dashboard-insert-bookmark-shortmenu)
     (agenda    . dashboard-insert-org-agenda-shortmenu)))
  (dashboard-items '(recents bookmarks agenda))

  (dashboard-icon-type 'nerd-icons)
  (dashboard-set-heading-icons t)
  (dashboard-set-file-icons t)     ;; display icons on both GUI and terminal
  
  (dashboard-banner-logo-title "We'll protect this planet. You and me.")
  (dashboard-set-init-info t)
  (dashboard-display-icons-p t)  ;; This makes sure the icons are displayed before the dashboard loads
  (dashboard-week-agenda t)
  (dashboard-startupify-list '(dashboard-insert-banner
                                    dashboard-insert-newline
                                    dashboard-insert-banner-title
                                    dashboard-insert-newline
                                    dashboard-insert-items
                                    dashboard-insert-init-info
         			    ))	
  )

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

(add-to-list 'evil-motion-state-modes 'elfeed-search-mode)
(add-to-list 'evil-motion-state-modes 'elfeed-show-mode)

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

(setq org-todo-keyword-faces
      '(
        ("TODO" . "#ed8796")
        ("NEXT" . "#a6da95")
        ("WAIT" . "#8bd5ca")
        ("HOLD" . "#c6a0f6")
        ("IDEA" . "#b7bdf8")
         ))

(setq org-todo-keywords '(
    (sequence
     "TODO(t)" ; doing later
     "NEXT(n)" ; doing now or soon
     "|"
     "DONE(d)" ; done
     )
    (sequence
     "WAIT(w)" ; waiting for some external change (event)
     "HOLD(h)" ; waiting for some internal change (of mind)
     "IDEA(i)" ; maybe someday
     "|"
     "STOP(s@/!)" ; stopped waiting, decided not to work on it
     ))
)

(org-super-agenda-mode)

(set-face-attribute 'org-date nil :foreground (catppuccin-get-color 'subtext0) :weight 'normal :height 0.80)
(set-face-attribute 'org-agenda-date nil :foreground (catppuccin-get-color 'mauve) :weight 'bold :height 1.25)
(set-face-attribute 'org-agenda-date-today nil :foreground (catppuccin-get-color 'mauve) :height 1.25)
(set-face-attribute 'org-agenda-date-weekend-today nil :foreground (catppuccin-get-color 'mauve) :height 1.25)
(set-face-attribute 'org-super-agenda-header nil :foreground (catppuccin-get-color 'pink) :weight 'bold :height 1.05)

(setq org-habit-toggle-habits t)
(setq org-agenda-hide-tags-regexp ".*")

(setq org-agenda-custom-commands
      '(
        ("d" "Daily Agenda"
         (
          (agenda ""
                  (
                   (org-agenda-span 1)
                   ;;(org-deadline-warning-days 0)
                   (org-agenda-day-face-function (lambda (date) 'org-agenda-date))
                   (org-super-agenda-date-format "%A %-e %B %Y")
                   (org-agenda-overriding-header "")
                   )
                  )
          (alltodo "" ((org-agenda-block-separator nil)
                       (org-agenda-overriding-header "")
                       
                       (org-super-agenda-groups
                        '(;; Each group has an implicit boolean OR operator between its selectors.
                          (:name "Important"
                                 ;; Single arguments given alone
                                 :priority "A")
                          (:name "Next to do"
                                 :todo "NEXT")
                          (:name "Buy"
                                 :tag "Buy")
                          (:name "Projects"
                                 :tag "Project")
                          ;; Groups supply their own section names when none are given
                          ;;(:todo ("WAIT" "HOLD") :order 8)  ; Set order of this section
                          (:priority<= "B"
                                       ;; Show this section after "Today" and "Important", because
                                       ;; their order is unspecified, defaulting to 0. Sections
                                       ;; are displayed lowest-number-first.
                                       :order 1)
                          ;; After the last group, the agenda will display items that didn't
                          ;; match any of these groups, with the default order position of 99
                          )
                        )
                       )
                   )
          )
         )
        )
      )

(use-package org-bullets
  :init
  (setq org-bullets-bullet-list '("ᐁ" "†")))
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

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
)

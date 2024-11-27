;;
;; Package management
;; Using straight.el and use-package
;;
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(setq straight-use-package-by-default 1)

(straight-use-package 'use-package)

;;
;; Emacs + editor configurations
;;
(use-package emacs
  ;;
  ;; Configs
  ;;
  :custom
  (enable-recursive-minibuffers t)

  (inhibit-startup-message t)

  ;; Use Tab for accepting auto-completion
  (tab-always-indent 'complete)

  ;; Make sure emacs occupies all available space, and prevent gaps between emacs and other windows
  (frame-resize-pixelwise t)

  ;; Disable auto-save
  (auto-save-default nil)

  ;;
  ;; Hooks
  ;;
  :hook
  (before-save . delete-trailing-whitespace))

(use-package exec-path-from-shell
  :init
  (exec-path-from-shell-initialize))

(use-package avy
  :bind
  ("C-;" . avy-goto-char-timer)
  ("C-'" . avy-next)
  ("C-\"" . avy-prev))

(use-package editorconfig
  :config
  (editorconfig-mode 1))

(use-package guru-mode
  :hook
  (prog-mode . guru-mode)
  :custom
  (guru-warn-only 1))

(use-package crux
  :bind
  ("C-<return>" . crux-smart-open-line)
  ("C-S-<return>" . crux-smart-open-line-above)
  ("C-c d" . crux-duplicate-current-line-or-region)
  ("M-o" . crux-other-window-or-switch-buffer)
  ("C-c i" . crux-find-user-init-file)
  ("C-a" . crux-move-beginning-of-line))

(use-package easy-kill
  :bind
  ([remap kill-ring-save] . easy-kill))

(use-package hl-todo
  :hook
  (prog-mode . hl-todo-mode))

(use-package expand-region
  :bind
  ("C-=" . er/expand-region)
  ("C-+" . er/contract-region))

;;
;; Theme
;;
(set-face-attribute 'default nil :font "JetBrains Mono 15")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("4594d6b9753691142f02e67b8eb0fda7d12f6cc9f1299a49b819312d6addad1d" "f5f80dd6588e59cfc3ce2f11568ff8296717a938edd448a947f9823a4e282b66" default)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Nice modeline, going well together with doom-themes
;; NOTE Make sure to install nerd icons with `nerd-icons-install-fonts'
(use-package doom-modeline
  :config
  (doom-modeline-mode 1))

(use-package doom-themes
  :config
  (load-theme 'doom-tokyo-night))

;;
;; Editor improvements
;;

;; Store backup and autosave in temp directory
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;;
;; Searching
;;
(use-package which-key
  :config
  (which-key-mode))

(use-package savehist
  :config
  (savehist-mode))

(use-package vertico
  :config
  (vertico-mode))

(use-package marginalia
  :config
  (marginalia-mode))

(use-package orderless
  :custom
  (completion-styles '(orderless partial-completion basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package consult
  :bind
  ("C-s" . consult-line)
  ("C-x b" . consult-buffer)
  ("C-c s r" . consult-ripgrep)
  ("C-c s g" . consult-grep)
  ("C-c s G" . consult-git-grep))

(use-package embark
  :bind
  ("C-." . embark-act))

(use-package embark-consult
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

;;
;; Windows
;;

(use-package ace-window
  :bind
  ("M-p" . ace-window))

;;
;; Programming
;;

;; Projects
(use-package projectile
  :config
  (projectile-mode)
  :bind
  ("s-p" . projectile-command-map))

;; Treesitter
(use-package treesit-auto
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

;; Autocompletion
(use-package corfu
  :custom
  (corfu-cycle t)
  (corfu-auto t)
  (corfu-auto-delay 0)
  (corfu-auto-prefix 1)
  (corfu-popupinfo-delay 0)

  :config
  (global-corfu-mode 1)
  (corfu-popupinfo-mode 1)
  (keymap-unset corfu-map "RET"))

(use-package cape
  :bind ("C-c p" . cape-prefix-map)
  :hook
  (completion-at-point . cape-dabbrev)
  (completion-at-point . cape-keyword)
  (completion-at-point . cape-file))

;; LSP
(use-package lsp-mode
  :custom
  (lsp-completion-provider :none)
  :init
  (defun my/lsp-mode-setup-completion ()
    (setf (alist-get 'styles (alist-get 'lsp-capf completion-category-defaults))
          '(orderless))) ;; Configure orderless
  :hook
  (lsp-completion-mode . my/lsp-mode-setup-completion)
  (ruby-ts-mode . lsp-deferred)
  (c-ts-mode . lsp-deferred)
  (javascript-mode . lsp-deferred)
  (typescript-ts-mode . lsp-deferred)
  (css-ts-mode . lsp-deferred)
  :commands (lsp lsp-deferred))

(use-package lsp-ui :commands lsp-ui-mode)

;; Linting
(use-package flycheck
  :hook
  (prog-mode . flycheck-mode))

;; Lisp
(use-package rainbow-delimiters
  :hook
  (prog-mode . rainbow-delimiters-mode))

;; Smart parens
(use-package puni
  :config
  (puni-global-mode)
  :hook
  (term-mode . puni-disable-puni-mode))

;; Web
(use-package web-mode
  :mode
  (("\\.erb\\'" . web-mode)))

;; Tailwind
(use-package lsp-tailwindcss
  :after lsp-mode
  :init
  (setq lsp-tailwindcss-add-on-mode t))

;; Ruby
(use-package rinari)

;; Snippets
(use-package yasnippet
  :config
  (yas-global-mode 1)
  :bind
  ("C-," . yas-insert-snippet))

(use-package yasnippet-snippets)

;;
;; Terminal emulation
;;
(use-package vterm
  :bind
  ("C-c t" . vterm-other-window))

;;
;; Git
;;
(use-package magit
  :bind
  ("C-c g g" . magit))

;;
;; Org mode
;;

(use-package org
  :custom
  (org-hide-emphasis-markers t))

(use-package org-bullets
  :hook
  (org-mode . (lambda () (org-bullets-mode 1))))

(use-package org-roam
  :custom
  (org-roam-directory (file-truename "~/org-roam"))
  (org-roam-completion-everywhere t)
  :config
  (unless (file-exists-p org-roam-directory)
    (make-directory org-roam-directory))
  (org-roam-db-autosync-mode)
  :bind (("C-c o f" . org-roam-node-find)
	 ("C-c o i" . org-roam-node-insert)
	 ("C-c o t" . org-roam-dailies-goto-today)))

(use-package consult-notes
  :commands
  (consult-notes consult-notes-search-in-all-notes)
  :custom
  (consult-notes-file-dir-sources '(("Org Roam" ?r "~/org-roam/")))
  :bind
  ("C-c s o" . consult-notes-search-in-all-notes)
  ("C-c s n" . consult-notes)
  :config
  (consult-notes-org-roam-mode))

(provide 'init)
;;; init.el ends here

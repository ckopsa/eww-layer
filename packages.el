;;; packages.el --- eww layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2017 Sylvain Benner & Contributors
;;
;; Author: Colton Kopsa <coljamkop@gmail.com>
;;         Daniel Nicolai <dalanicolai@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;;; Commentary:

;; See the Spacemacs documentation and FAQs for instructions on how to implement
;; a new layer:
;;
;;   SPC h SPC layers RET
;;
;;
;; Briefly, each package to be installed or configured by this layer should be
;; added to `eww-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `eww/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `eww/pre-init-PACKAGE' and/or
;;   `eww/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:

(defconst eww-packages
  '(
    ;; A local package
    (eww :location built-in)
    texfrag
    ;; (ace-link :location elpa)
    ;; (helm-net :location elpa)
    )
  "The list of Lisp packages required by the eww layer.

Each entry is either:

1. A symbol, which is interpreted as a package to be installed, or

2. A list of the form (PACKAGE KEYS...), where PACKAGE is the
    name of the package to be installed or loaded, and KEYS are
    any number of keyword-value-pairs.

    The following keys are accepted:

    - :excluded (t or nil): Prevent the package from being loaded
      if value is non-nil

    - :location: Specify a custom installation location.
      The following values are legal:

      - The symbol `elpa' (default) means PACKAGE will be
        installed using the Emacs package manager.

      - The symbol `local' directs Spacemacs to load the file at
        `./local/PACKAGE/PACKAGE.el'

      - A list beginning with the symbol `recipe' is a melpa
        recipe.  See: https://github.com/milkypostman/melpa#recipe-format")

(defun eww/init-eww ()
  (use-package eww
    :defer t
    :init
    (spacemacs//eww-setup-transient-state)
    :config
    (progn
      (define-key eww-link-keymap "f" 'eww-follow-link)
      (define-key eww-link-keymap "F" (lambda () (interactive) (eww-follow-link 2)))

      (let ((mode 'eww-mode))
        (spacemacs/declare-prefix-for-mode mode "mv" "view")
        (spacemacs/declare-prefix-for-mode mode "ml" "list")
        (spacemacs/set-leader-keys-for-major-mode mode
          "s" 'helm-google-suggest
          "S" 'browse-web
          "t" 'spacemacs/eww-render-latex
          "r" 'eww-reload
          "p" 'eww-previous-url
          "n" 'eww-next-url
          "h" 'eww-list-histories
          "d" 'eww-download
          "a" 'eww-add-bookmark
          "lb" 'eww-list-buffers
          "lo" 'eww-list-bookmarks
          "vx" 'eww-browse-with-external-browser
          "vf" 'eww-toggle-fonts
          "vr" 'eww-readable)
        (evil-define-key 'normal eww-mode-map
          (kbd "C-o") 'eww-back-url
          (kbd "C-i") 'eww-forward-url
          "[" 'eww-back-url
          "]" 'eww-forward-url
          "L" 'spacemacs/eww-jump-next-buffer
          "H" 'spacemacs/eww-jump-previous-buffer
          (kbd "C-j") 'shr-next-link
          (kbd "C-k") 'shr-previous-link
          "o" 'ace-link-eww))

      (let ((mode 'eww-history-mode))
        (spacemacs/set-leader-keys-for-major-mode mode
          "f" 'eww-history-browse)
        (evil-define-key 'normal eww-history-mode-map "f" 'eww-history-browse
          "q" 'quit-window))

      (let ((mode 'eww-bookmark-mode))
        (spacemacs/set-leader-keys-for-major-mode mode
          "d" 'eww-bookmark-kill
          "y" 'eww-bookmark-yank
          "f" 'eww-bookmark-browse)
        (evil-define-key 'normal eww-bookmark-mode-map
          "q" 'quit-window
          "f" 'eww-bookmark-browse
          "d" 'eww-bookmark-kill
          "y" 'eww-bookmark-yank))

      (let ((mode 'eww-buffers-mode))
        (spacemacs/set-leader-keys-for-major-mode mode
          "f" 'eww-buffer-select
          "d" 'eww-buffer-kill
          "n" 'eww-buffer-show-next
          "p" 'eww-buffer-show-previous)
        (evil-define-key 'normal eww-buffers-mode-map
          "q" 'quit-window
          "f" 'eww-buffer-select
          "d" 'eww-buffer-kill
          "n" 'eww-buffer-show-next
          "p" 'eww-buffer-show-previous)))))

(defun eww/init-texfrag ()
  (use-package texfrag
    :defer t))
;;; packages.el ends here

;;; funcs.el --- eww layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2017 Sylvain Benner & Contributors
;;
;; Author: Colton Kopsa <coljamkop@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(defvar spacemacs--eww-buffers nil)

(defun spacemacs/eww-render-latex ()
  (interactive)
  (call-interactively #'texfrag-mode)
  (when texfrag-mode
    (eww-reload)))

(defun spacemacs//eww-setup-transient-state ()

  "Setup eww transient state with toggleable help hint.

Beware: due to transient state's implementation details this
function must be called in the :init section of `use-package' or
full hint text will not show up!"
  (defvar spacemacs--eww-ts-full-hint-toggle t
    "Toggle the state of the eww transient state documentation.")

  (defvar spacemacs--eww-ts-full-hint nil
    "Display full pdf transient state documentation.")

  (defvar spacemacs--eww-ts-minified-hint nil
    "Display minified pdf transient state documentation.")

  (defun spacemacs//eww-ts-toggle-hint ()
    "Toggle the full hint docstring for the eww transient state."
    (interactive)
    (setq spacemacs--eww-ts-full-hint-toggle
          (not spacemacs--eww-ts-full-hint-toggle)))

  (defun spacemacs//eww-ts-hint ()
    "Return a condensed/full hint for the eww transient state"
    (concat
     " "
     (if spacemacs--eww-ts-full-hint-toggle
         spacemacs--eww-ts-full-hint
       (concat "[" (propertize "?" 'face 'hydra-face-red) "] help"))))

  (spacemacs|transient-state-format-hint eww
    spacemacs--eww-ts-full-hint
    (format "\n[_?_] toggle help
 Navigation^^^^                Scale/Fit^^                    Annotations^^       Actions^^           Other^^
 ----------^^^^--------------- ---------^^------------------  -----------^^------ -------^^---------- -----^^---
 [_[_/_]_] history back/forw   [_v_] toggle visual-line-mode  [_al_] list         [_t_] toggle latex  [_q_] quit
 [_H_/_L_] prev/next eww-buff  [_w_] toggle writeroom-mode    ^^                  [_c_] cycle theme
 ^^^^                          [_+_] zoom-in
 ^^^^                          [_-_] zoom-out
 ^^^^                          [_=_] unzoom"))

  (spacemacs|define-transient-state eww
    :title "Eww Transient State"
    :hint-is-doc t
    :dynamic-hint (spacemacs//eww-ts-hint)
    :on-enter (setq which-key-inhibit t)
    :on-exit (setq which-key-inhibit nil)
    :evil-leader-for-mode (eww-mode . ".")
    :bindings
    ("?" spacemacs//eww-ts-toggle-hint)
    ;; Navigation
    ("["  eww-back-url)
    ("]"  eww-next-url)
    ("H"  spacemacs/eww-jump-previous-buffer)
    ("L"  spacemacs/eww-jump-next-buffer)
    ;; Scale/Fit
    ("w"  writeroom-mode)
    ("v" visual-line-mode)
    ("+" zoom-frm-in)
    ("-" zoom-frm-out)
    ("=" zoom-frm-unzoom)
    ;; Annotations
    ("al" pdf-annot-list-annotations :exit t)
    ;; Actions
    ("t" spacemacs/eww-render-latex)
    ("c" spacemacs/cycle-spacemacs-theme)
    ;; Other
    ("q" nil :exit t)))

(defun spacemacs//eww-get-buffers ()
  (dolist (buffer (buffer-list))
    (with-current-buffer buffer
      (when (and (derived-mode-p 'eww-mode)
                 (not (memq buffer spacemacs--eww-buffers)))
        (push buffer
              spacemacs--eww-buffers))))
  (unless spacemacs--eww-buffers
    (error "No eww buffers"))
  ;; remove deleted buffers maintaining order
  (dolist (buffer spacemacs--eww-buffers)
    (if (not (memq buffer (buffer-list)))
        (delq buffer spacemacs--eww-buffers)))
  spacemacs--eww-buffers)

(defun spacemacs//eww-next-buffer (buff)
  (let* ((eww-buffers (spacemacs//eww-get-buffers))
         (eww-buffer-pos (seq-position eww-buffers buff)))
    (if (eq eww-buffer-pos (1- (length eww-buffers)))
        (car eww-buffers)
      (nth (1+ eww-buffer-pos) eww-buffers))))

(defun spacemacs//eww-previous-buffer (buff)
  (let* ((eww-buffers (spacemacs//eww-get-buffers))
         (eww-buffer-pos (seq-position eww-buffers buff)))
    (if (zerop eww-buffer-pos)
        (car (last eww-buffers))
      (nth (1- eww-buffer-pos) eww-buffers))))

(defun spacemacs/eww-jump-next-buffer ()
  (interactive)
  (pop-to-buffer-same-window (spacemacs//eww-next-buffer (current-buffer))))

(defun spacemacs/eww-jump-previous-buffer ()
  (interactive)
  (pop-to-buffer-same-window (spacemacs//eww-previous-buffer (current-buffer))))

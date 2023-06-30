;;; esdl-mode.el --- A major mode for editing EdgeDB schema definition files -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2023 Scott Trinh
;;
;; Author: Scott Trinh <scott@scotttrinh.com>
;; Maintainer: Scott Trinh <scott@scotttrinh.com>
;; Created: June 30, 2023
;; Modified: June 30, 2023
;; Version: 0.0.1
;; Homepage: https://github.com/scotttrinh/esdl-mode
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;;
;;; Syntax highlight for EdgeDB schema definition files.
;;
;;
;;; Code:

(provide 'esdl-mode)

(defvar esdl-mode-syntax-table nil
  "Syntax table for `esdl-mode'.")

(setq esdl-mode-syntax-table
      (let ((synTable (make-syntax-table)))
        ;; python style comment: "# …"
        (modify-syntax-entry ?# "<" synTable)
        (modify-syntax-entry ?\n ">" synTable)
        synTable))

(setq esdl-font-lock-keywords
      (let* (
             ;; Keywords
             (x-keywords-regexp "\\(module\\|abstract type\\|type\\|constraint\\|exclusive\\|rewrite\\|trigger\\|extending\\|required\\|multi\\|single\\|property\\|link\\|scalar\\)")
             ;; Scalar types
             (x-scalar-types-regexp "\\(str\\|bool\\|int16\\|int32\\|int64\\|float32\\|float64\\|bigint\\|decimal\\|json\\|uuid\\|bytes\\|datetime\\|duration\\)")
             ;; Properties in an attribute, e.g. `fields: [MediaTypeId]'.
             (x-properties-regexp "[a-zA-Z_-]+:")
             ;; Builtin functions. E.g. `autoincrement()'
             (x-attribute-functions-regexp "\\([a-z_]\\)+\(\.*\)")
             ;; Constants
             (x-constants-regexp "\\(true\\|false\\)")
             ;; Custom types
             (x-custom-type-regexp "[A-Z]+[a-zA-Z]+"))
        `(
          ;; order matters
          (,x-attribute-functions-regexp . (1 font-lock-function-name-face))
          (,x-keywords-regexp . (1 font-lock-keyword-face))
          (,x-scalar-types-regexp . (1 font-lock-type-face))
          (,x-properties-regexp . font-lock-variable-name-face)
          (,x-constants-regexp . font-lock-constant-face)
          (,x-custom-type-regexp . font-lock-type-face))))

;;;###autoload
(define-derived-mode esdl-mode js2-mode "ESDL"
  "EdgeDB SDL major mode."
  :syntax-table esdl-mode-syntax-table

  (setq-default indent-tabs-mode nil)
  (setq tab-width 2)
  (setq c-basic-offset 2)
  (setq c-syntactic-indentation nil)
  (setq js-indent-level 2)
  (setq-local comment-start "#")

  (setq font-lock-defaults '((esdl-font-lock-keywords)))
  ;; disable syntax checking
  (setq-local js2-mode-show-parse-errors nil)
  (setq-local js2-mode-show-strict-warnings nil))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.esdl\\'" . esdl-mode))

;;; esdl-mode.el ends here

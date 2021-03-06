;;;;;;;;;;;;;;;; c mode ;;;;;;;;;;;;;;;;

(defun c-mode-hook ()
  (setq tab-width 8
	c-basic-offset 4
	indent-tabs-mode nil)
  (font-lock-mode 1))

(eval-after-load 'cc-mode
  '(add-hook 'c-mode-hook 'c-mode-hook))

(defun objc-mode-setup-hook ()
  (setq tab-width 8
	c-basic-offset 4
	indent-tabs-mode nil
	truncate-lines t))

(eval-after-load 'cc-mode
  '(add-hook 'objc-mode-hook 'objc-mode-setup-hook))

;;;;;;;;;;;;;;;; java mode ;;;;;;;;;;;;;;;;

(defun java-beginning-of-method ()
  (when (re-search-backward (concat "^\\(  \\|\t\\)"
				    "\\(synchronized"
				    "\\|public"
				    "\\|protected"
				    "\\|private\\)")
			    nil
			    'move
			    1)
    (goto-char (1- (match-end 0)))))

(defun java-end-of-method ()
  (let ((result (re-search-forward "^  }" nil t)))
    (end-of-line)
    (and result t)))

(defun java-mode-hook ()
  (setq c-basic-offset 2
	tab-width 2
	c-set-style "linux"
	indent-tabs-mode nil)
  (when (boundp 'outline-regexp)
    (outline-minor-mode 1)
    (setq outline-regexp (concat "^\\(  [  ]*\\|\\)"
                                 "\\(synchronized"
                                 "\\|public"
                                 "\\|protected"
                                 "\\|private"
                                 ;; "\\|//"
                                 "\\)")))
  (font-lock-mode 1))

(defun java-mode-init ()
  ;; (setenv "JAVA_HOME" (opt-path "jdk"))
  (add-hook 'java-mode-hook 'java-mode-hook)
  (require 'compile)
  (setq compilation-error-regexp-alist
        (append
         (list
          ;; works for jikes
          '("^\\s-*\\[[^]]*\\]\\s-*\\(.+\\):\\([0-9]+\\):\\([0-9]+\\):[0-9]+:[0-9]+:"
            1 2 3)
          ;; works for javac
          '("^\\s-*\\[[^]]*\\]\\s-*\\(.+\\):\\([0-9]+\\):" 1 2)

          ;; clojure.test
          '("^FAIL in (.*) (\\([^:]*\\):\\([0-9]+\\)" 1 2)
          '("^ERROR in (.*) (\\([^:]*\\):\\([0-9]+\\)" 1 2))
         compilation-error-regexp-alist)))

;; (setq auto-mode-alist (cons '("\\.cs\\'" . java-mode) auto-mode-alist))

(eval-after-load 'cc-mode
  '(java-mode-init))

;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;;numbers are disabled. For relative line numbers, set this to `relative'.
;; (setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(setq user-full-name "Klaudiusz Kowalski"

      ;; When I bring up Doom's scratch buffer with SPC x, it's often to play
      ;; with elisp or note something down (that isn't worth an entry in my
      ;; notes). I can do both in `lisp-interaction-mode'.
      doom-scratch-initial-major-mode 'lisp-interaction-mode

      doom-theme 'doom-tomorrow-night
      doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 28)
      doom-variable-pitch-font (font-spec :family "DejaVu Sans" :size 30)

      ;; I install nerd-icons via nixos
      nerd-icons-font-names '("SymbolsNerdFontMono-Regular.ttf")

      ;; Line numbers slow Emacs down and aren't terribly useful to me, except
      ;; when pair programming.
      display-line-numbers-type 'relative)

(custom-theme-set-faces! 'doom-tomorrow-night
   '(default :background "#1a1a1a")
   '(solaire-default-face :background "#161616"))

;; (add-to-list 'default-frame-alist '(alpha-background . 80)) ;;

(add-to-list 'default-frame-alist '(inhibit-double-buffering . t)) ; prevents flickering

(add-to-list 'safe-local-variable-directories doom-modules-dir)

;;
;;; Packages

(setq browse-url--inhibit-pgtk t)

;;
;;; Modules

(add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))

;;; :completion corfu
;; IMO, modern editors have trained a bad habit into us all: a burning need for
;; completion all the time -- as we type, as we breathe, as we pray to the
;; ancient ones -- but how often do you *really* need that? I say rarely, so opt
;; for manual completion:
(after! corfu
  (setq corfu-auto nil))

;;; :tools tree-sitter
(defun kk/js-ts-mode-disable-jsdoc-range-h ()
  "Disable embedded jsdoc ranges in `js-ts-mode` on Emacs 30.2.

Emacs 30.2 ships a jsdoc range query that fails against Doom's newer
JavaScript grammar pins."
  (when (string-prefix-p "30.2" emacs-version)
    (setq-local treesit-range-settings nil)))

(defun kk/treesit-javascript-font-lock-level-a (fn &rest args)
  "Lower JS tree-sitter font-lock during mode setup on Emacs 30.2."
  (if (string-prefix-p "30.2" emacs-version)
      (let ((treesit-font-lock-level 2))
        (apply fn args))
    (apply fn args)))

(after! js
  (unless (advice-member-p #'kk/treesit-javascript-font-lock-level-a 'js-ts-mode)
    (advice-add 'js-ts-mode :around #'kk/treesit-javascript-font-lock-level-a))
  (add-hook 'js-ts-mode-hook #'kk/js-ts-mode-disable-jsdoc-range-h))

(defun kk/treesit-typescript-font-lock-level-a (fn &rest args)
  "Lower TS/TSX tree-sitter font-lock during mode setup.

Work around Emacs 30.2 query failures with newer TypeScript grammars."
  (let ((treesit-font-lock-level 2))
    (apply fn args)))

(after! typescript-ts-mode
  (unless (advice-member-p #'kk/treesit-typescript-font-lock-level-a 'typescript-ts-mode)
    (advice-add 'typescript-ts-mode :around #'kk/treesit-typescript-font-lock-level-a))
  (unless (advice-member-p #'kk/treesit-typescript-font-lock-level-a 'tsx-ts-mode)
    (advice-add 'tsx-ts-mode :around #'kk/treesit-typescript-font-lock-level-a)))

;;; :ui modeline
;; An evil mode indicator is redundant with cursor shape
(setq doom-modeline-modal nil)

;;; :editor evil
;; Focus new window after splitting
(setq evil-split-window-below t
      evil-vsplit-window-right t)

;; Implicit /g flag, because I rarely use it without
(setq evil-ex-substitute-global t)

;; Implicit /g flag, because I rarely use it without
(setq evil-ex-substitute-global t)

;;; :tools magit
(setq magit-show-long-lines-warning nil
      magit-repository-directories '(("~/projects" . 2))
      magit-save-repository-buffers nil
      ;; Don't restore the wconf after quitting magit, it's jarring
      magit-inhibit-save-previous-winconf t
      evil-collection-magit-want-horizontal-movement t
      magit-openpgp-default-signing-key "FA1FADD9440B688CAA75A057B60957CA074D39A3"
      transient-values '((magit-rebase "--autosquash" "--autostash")
                         (magit-pull "--rebase" "--autostash")
                         (magit-revert "--autostash")))

;;; :ui doom-dashboard
(setq fancy-splash-image (file-name-concat doom-user-dir "splash.xpm"))
;; Hide the menu for as minimalistic a startup screen as possible.
(setq +dashboard-functions '(+dashboard-widget-banner))

;;; :app everywhere
(after! emacs-everywhere
  ;; Easier to match with a bspwm rule:
  ;;   bspc rule -a 'Emacs:emacs-everywhere' state=floating sticky=on
  (setq emacs-everywhere-frame-name-format "emacs-anywhere")

  ;; Leave it to BSPWM to position/size the emacs-everywhere window, rather than
  ;; place it at the cursor position (which could be anywhere).
  (remove-hook 'emacs-everywhere-init-hooks #'emacs-everywhere-set-frame-position))

(use-package! markdown-mermaid
  :after markdown-mode
  :bind (:map markdown-mode-map
              ("C-c m" . markdown-mermaid-preview))
  :config
  ;; Tells Emacs where to find the CLI tool
  (setq markdown-mermaid-mmdc-path (executable-find "mmdc")))

(use-package! claude-code-ide
  :defer t
  :commands (claude-code-ide
             claude-code-ide-menu
             claude-code-ide-continue
             claude-code-ide-resume
             claude-code-ide-stop
             claude-code-ide-toggle
             claude-code-ide-toggle-recent
             claude-code-ide-switch-to-buffer
             claude-code-ide-list-sessions
             claude-code-ide-send-prompt
             claude-code-ide-insert-at-mentioned
             claude-code-ide-check-status)
  :init
  ;; Prevent Doom's popup system from hijacking Claude Code side-window
  (set-popup-rule! "^\\*claude-code" :ignore t)

  ;; Keybindings: SPC c l ("code > claude")
  (map! :leader
        (:prefix-map ("c" . "code")
                     (:prefix ("l" . "claude")
                      :desc "Start Claude Code"       "l" #'claude-code-ide
                      :desc "Transient menu"          "m" #'claude-code-ide-menu
                      :desc "Continue session"        "c" #'claude-code-ide-continue
                      :desc "Resume conversation"     "r" #'claude-code-ide-resume
                      :desc "Stop session"            "q" #'claude-code-ide-stop
                      :desc "Toggle window"           "t" #'claude-code-ide-toggle
                      :desc "Toggle recent (global)"  "T" #'claude-code-ide-toggle-recent
                      :desc "Switch to buffer"        "b" #'claude-code-ide-switch-to-buffer
                      :desc "List sessions"           "s" #'claude-code-ide-list-sessions
                      :desc "Send prompt"             "p" #'claude-code-ide-send-prompt
                      :desc "Send selection"          "a" #'claude-code-ide-insert-at-mentioned
                      :desc "Check status"            "?" #'claude-code-ide-check-status)))

  :config
  (setq claude-code-ide-terminal-backend 'vterm
        claude-code-ide-use-side-window t
        claude-code-ide-window-side 'right
        claude-code-ide-window-width 90
        claude-code-ide-focus-on-open t
        claude-code-ide-use-ide-diff t
        claude-code-ide-focus-claude-after-ediff t
        claude-code-ide-show-claude-window-in-ediff t
        claude-code-ide-diagnostics-backend 'flycheck
        claude-code-ide-vterm-anti-flicker t
        claude-code-ide-vterm-render-delay 0.005
        claude-code-ide-prevent-reflow-glitch t)

  ;; Enable MCP server — exposes xref, tree-sitter, imenu, project info to Claude
  (claude-code-ide-emacs-tools-setup))

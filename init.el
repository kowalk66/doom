;;; $DOOMDIR/init.el -*- lexical-binding: t; -*-

(doom! ;;((sources)
       ;; (flags))

       :completion
       (corfu +orderless +dabbrev +icons)
       (vertico +icons)

       :ui
       (doom +tabs)
       dashboard
       modeline
       hl-todo
       indent-guides
       ophints
       treemacs
       ophints           ; highlight the region an operation acts on
       (popup +defaults)
       (vc-gutter +pretty)
       (workspaces +tabs)

       :editor
       (evil +everywhere)
       file-templates
       fold
       format
       multiple-cursors
       rotate-text
       snippets
       (whitespace +guess +trim)

       :emacs
       (dired +dirvish +icons)
       electric
       tramp
       undo
       vc

       :term
       eshell
       vterm

       :checkers
       (syntax +childframe)
       spell

       :tools
       debugger
       direnv
       editorconfig
       (eval +overlay)
       (lookup +docsets +dictionary)
       llm
       (lsp +eglot)
       (magit +childframe)
       make
       (terraform +lsp)
       pdf
       tree-sitter
       ;; upload

       :os
       ;; tty

       :lang
       (graphql +lsp)    ; Give queries a REST
       (go +lsp +tree-sitter)         ; the hipster dialect
       beancount
       common-lisp
       (cc +lsp +tree-sitter)
       emacs-lisp
       (gdscript +lsp +tree-sitter)
       janet
       (java +lsp)       ; the poster child for carpal tunnel syndrome
       (javascript +lsp +tree-sitter)
       (json +tree-sitter +lsp)
       (lua +lsp +tree-sitter)
       (markdown +tree-sitter) ;; +grip?
       ;; (nix +lsp +tree-sitter)
       (org +dragndrop +roam2 +pretty +forge +gnuplot)
       (python +lsp +tree-sitter +uv +pyright)
       (rust +tree-sitter)
       (sh +powershell +fish +lsp)
       (yaml +lsp +tree-sitter)
       ruby
       (web +tree-sitter +lsp)
       (zig +lsp +tree-sitter)

       :app
       calendar
       everywhere

       :config
       ;; literate
       (default +bindings +gnupg +smartparens))

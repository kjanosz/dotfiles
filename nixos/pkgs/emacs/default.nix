{ pkgs, ... }:

let
  base = (pkgs.emacsPackagesNgGen pkgs.emacs25).override (super: self: {
    inherit (self.melpaPackages)
    # Use these from MELPA Unstable:
    intero ranger;
  });
in base.emacsWithPackages (epkgs: with epkgs; [
  # package management
  use-package

  # general
  base16-theme
  rainbow-delimiters
  smartparens
  switch-window
  company
  helm
  flycheck
  magit
  neotree
  projectile
  ranger
  helm-ag
  helm-projectile
  
  # go
  go-mode
  company-go

  # haskell
  haskell-mode
  intero
  shm
  company-cabal
  company-ghc
  helm-ghc
  flycheck-haskell

  # idris
  idris-mode
  helm-idris
  
  # rust 
  cargo
  racer
  rust-mode
  company-racer
  flycheck-rust

  # scala
  ensime
  sbt-mode
  scala-mode

  # other langs
  ein
  geiser
  web-mode

  # other
  ansible
  yaml-mode
  company-ansible 

  # nix
  nix-mode
  nixos-options
  company-nixos-options
  helm-nixos-options

  # text - LaTeX, Markdown, Org mode, Pandoc
  auctex
  markdown-mode
  org
  pandoc-mode
  company-auctex
])

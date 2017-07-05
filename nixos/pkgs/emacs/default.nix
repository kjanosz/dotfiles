{ pkgs, ... }:

let
  baseNoGTK = pkgs.emacs25.override {
    # Use ‘lucid’ toolkit because of following bug in GTK: https://bugzilla.gnome.org/show_bug.cgi?id=85715
    withX = true;
    withGTK2 = false;
    withGTK3 = false;
  };
  
  base = (pkgs.emacsPackagesNgGen baseNoGTK).override (super: self: {
    inherit (self.melpaPackages)
    # Use these from MELPA Unstable:
    ensime intero ranger;
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

  # elixir
  alchemist
  elixir-mode
  
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
  ledger-mode
  markdown-mode
  org
  pandoc-mode
  company-auctex
])

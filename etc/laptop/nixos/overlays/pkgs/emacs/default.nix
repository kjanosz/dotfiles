{ pkgs, ... }:

let
  # 2018-11-01T10:06:56-04:00
  proofgeneral = pkgs.emacsPackages.proofgeneral_HEAD.overrideAttrs (oldAttrs: rec {
    name = "proof-general-${version}";
    version = "HEAD";

    src = pkgs.fetchFromGitHub {
      owner = "ProofGeneral";
      repo = "PG";
      rev = "15cf5a3f1e3ba35d832e1464a1b729905aed78a8";
      sha256 = "0xcgm9wg3cagkv3amq2rc0ij9jr81nijzlraxmv39i3w1qr69pdr";
    };
  });

  baseNoGTK = pkgs.emacs25.override {
    # Use ‘lucid’ toolkit because of following bug in GTK: https://bugzilla.gnome.org/show_bug.cgi?id=85715
    withX = true;
    withGTK2 = false;
    withGTK3 = false;
  };
  
  base = (pkgs.emacsPackagesNgGen baseNoGTK);
in base.emacsWithPackages (epkgs: with epkgs; with epkgs.melpaPackages; [
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

  # coq
  proofgeneral
  coq-commenter
  company-coq

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

  # lisp
  geiser
  slime
  
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

  # data science
  ein
  julia-mode

  # other langs
  web-mode

  # other
  ansible
  mmm-mode
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
  org-journal
  pandoc-mode
  company-auctex
])

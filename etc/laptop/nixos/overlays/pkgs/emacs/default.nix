{ pkgs, ... }:

let
  # 2018-11-01T10:06:56-04:00
  proofgeneral = pkgs.emacsPackages.proofgeneral_HEAD.overrideAttrs (oldAttrs: rec {
    name = "proof-general-${version}";
    version = "4.5";

    src = pkgs.fetchFromGitHub {
      owner = "ProofGeneral";
      repo = "PG";
      rev = "d53ded580e30d49e7a783280fd9ba96bc9c1c39c";
      sha256 = "17hf4mxpijvgd2jrffibcz9ps4vv8w2alcgmh78xjlb6mm0p3ls0";
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

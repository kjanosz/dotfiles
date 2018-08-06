{ pkgs, ... }:

let
  # 2018-04-22T12:37:22+02:00
  proofgeneral = pkgs.emacsPackages.proofgeneral_HEAD.overrideAttrs (oldAttrs: rec {
    name = "proof-general-${version}";
    version = "7379232";

    src = pkgs.fetchFromGitHub {
      owner = "ProofGeneral";
      repo = "PG";
      rev = "73792323172e289b531afc086d3f97323b28ecb6";
      sha256 = "15kxzbsqa5rb2z3yvjlngz5y4z6vr5gca3npdz75awxwiblajz86";
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

  # coq
  proofgeneral
  coq-commenter
  company-coq
  
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
  pandoc-mode
  company-auctex
])

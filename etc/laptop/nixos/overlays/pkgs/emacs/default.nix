{ pkgs, ... }:

let
  # 2018-09-27T17:45:38-04:00
  proofgeneral = pkgs.emacsPackages.proofgeneral_HEAD.overrideAttrs (oldAttrs: rec {
    name = "proof-general-${version}";
    version = "HEAD";

    src = pkgs.fetchFromGitHub {
      owner = "ProofGeneral";
      repo = "PG";
      rev = "5b7b84bc5b44fd87905b16a67367ece4e7fa7ee3";
      sha256 = "0bndhy7zz0rbcf3v0hb800678y4c0nna2a69m4mi4pch6ygyywn3";
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

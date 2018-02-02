{ pkgs, ... }:

let
  proofgeneral = pkgs.emacsPackages.proofgeneral_HEAD.overrideAttrs (oldAttrs: rec {
    name = "proof-general-${version}";
    version = "2017-12-11";

    src = pkgs.fetchFromGitHub {
      owner = "ProofGeneral";
      repo = "PG";
      rev = "08f4a234a669a2398be37c7fdab41ee9d3dcd6cd";
      sha256 = "161h1kfi32fpf8b1dq6xbf1ls74220b6cychbmcvixbvjqx522bd";
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

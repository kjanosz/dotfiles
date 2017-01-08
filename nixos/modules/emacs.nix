{ config, lib, pkgs, ... }:

let
  emacs = pkgs.emacsWithPackages (epkgs: with epkgs; [
    # package management
    use-package
  
    # appearance
    base16-theme
    rainbow-delimiters
    switch-window

    # code - VCS, linting, code completion, navigation
    company
    helm
    fic-mode
    flycheck
    magit
    neotree
    projectile
    ranger
    smartparens
    helm-ag
    helm-projectile

    # Go
    go-mode
    go-errcheck
    company-go

    # Haskell 
    haskell-mode
    intero
    shm
    company-cabal
    company-ghc
    flycheck-ghcmod
    flycheck-haskell
    helm-ghc

    # Idris
    idris-mode
    helm-idris

    # LISP 
    geiser

    # Rust 
    cargo
    racer
    rust-mode
    company-racer
    flycheck-rust

    # Scala
    ensime
    sbt-mode
    scala-mode

    # Other
    ein
    ess

    # nix
    nix-mode
    nixos-options
    company-nixos-options
    helm-nixos-options

    # text - LaTeX, Markdown, Org mode, Pandoc
    auctex
    markdown-mode
    org
    ox-pandoc
    ox-reveal
    pandoc-mode
    company-auctex

    # web
    psc-ide
    web-mode

    # misc - Ansible, Graphviz, PlantUML
    graphviz-dot-mode
    puml-mode
    yaml-mode
    ansible
    company-ansible 
  ]);
in
{
  environment.systemPackages = [ emacs ];

  systemd.user.services.emacs = {
    description = "An extensible, customizable, free/libre text editor — and more.";
    serviceConfig = {
      Type = "forking";
      Restart = "always";
      ExecStop = ''${emacs}/bin/emacsclient --eval (kill-emacs)'';
    };
    script = ''
      exec "$SHELL" --login -c "exec ${emacs}/bin/emacs --daemon"
    '';
  };
}

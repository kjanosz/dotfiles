{ config, lib, utils, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    idea.idea-community
    ack
    ag
    glide
    go
    gotools
    cabal-install
    ghc
    stack
    haskellPackages.idris
    cargo
    rustc
    rustfmt
    openjdk
    sbt
    scala
    scalafmt
    python
    racket
    nodePackages.node2nix
  ];

  services.emacs = {
    defaultEditor = true;
    enable = false;
    install = true;
    package = pkgs.emacs;
  };

  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;
}  

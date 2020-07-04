{ config, lib, pkgs, ... }:

with lib;

{
  environment.pathsToLink = [
    "/lib/summon"
  ];

  environment.systemPackages = with pkgs; [
    # general
    ack
    ag
    dbeaver
    docker_compose
    unstable.flyway
    gcc
    gdb
    gnumake
    insomnia
    nbstripout
    unstable.packer
    pre-commit
    protobuf3_9
    summon
    albacross.summon-aws-secrets # need to be to system package in order for pathsToLink to work
    # ide
    unstable.idea.idea-community
    vim
    vscode
    # haskell
    cabal2nix
    cabal-install
    ghc
    haskell-ide-engine
    # unstable.haskellPackages.apply-refact
    # unstable.haskellPackages.brittany
    # unstable.haskellPackages.HaRe
    # idris
    idris
    # lisp
    racket
    # proof
    acl2
    coq
    tla
    # purescript
    unstable.purescript
    # rust
    carnix
    cargo-expand
    llvmPackages.bintools
    rustChannels.stable
    rustracer
    # scala & jvm
    ammonite2_12
    ammonite2_13
    coursier
    mill
    openjdk11
    sbt
    scala
    visualvm
  ];

  environment.variables = {
    EDITOR = mkOverride 900 "${pkgs.vim}/bin/vim";
  };

  programs.adb.enable = true;

  virtualisation.docker.enable = true;

  virtualisation.libvirtd.enable = true;
  
  virtualisation.virtualbox = {
    host.enable = true;
    host.enableHardening = true;
    host.enableExtensionPack = true;
  };

  users.users.kj = {
    extraGroups = [ "adbusers" "docker" "kvm" "libvirtd" "vboxusers" ];
    packages = with pkgs; [
      python3Packages.arelle-headless 
      wireshark
    ];
  };  

  users.users.kjw = {
    extraGroups = [ "docker" "vboxusers" ];
    packages = with pkgs; [
      ansible
      awscli
      aws-vault
      go
      mysql
      nailgun
      nodejs
      unstable.slack
      albacross.terraform_0_12
    ];
  };

  # docker-containers.data-science = {
  #   cmd = [
  #     "jupyter-notebook"
  #     "--no-browser" 
  #     "--ip=127.0.0.1"
  #     "--notebook-dir=/tmp/dev"
  #     "--NotebookApp.token=''"
  #   ];
  #   extraDockerOptions = [
  #     "--network=host"
  #   ];
  #   image = "kjanosz/data-science";
  #   log-driver = "journald";
  #   user = "1000:100";
  #   volumes = [
  #     "/home/kj/Dev:/tmp/dev"
  #     "/home/kj/.local/share/jupyter:/.local/share/jupyter"
  #   ];
  #   workdir = "/tmp/dev";
  # };
  # systemd.services.docker-data-science = {
  #   requisite = [ "user@1000.service" ];
  # };
}  

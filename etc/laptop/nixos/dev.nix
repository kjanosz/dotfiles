{ config, lib, pkgs, ... }:

with lib;

let
  ociBackend = config.virtualisation.oci-containers.backend;
in
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
    flyway
    gcc
    gdb
    gnumake
    insomnia
    jq
    nbstripout
    packer
    pre-commit
    protobuf3_9
    summon
    vagrant
    wireshark
    # ide
    unstable.jetbrains.idea-community
    vim
    vscode
    # haskell
    cabal2nix
    cabal-install
    ghc
    haskellPackages.apply-refact
    haskellPackages.brittany
    haskellPackages.hlint
    # lisp
    racket
    # proof
    coq
    tlaps
    # rust
    cargo
    cargo-asm
    cargo-audit
    cargo-c
    cargo-cross
    cargo-depgraph
    cargo-expand
    cargo-flash
    cargo-msrv
    cargo-outdated
    cargo-rr
    llvmPackages.bintools
    rustChannels.stable
    rustup
    # scala & jvm
    ammonite_2_13
    ammonite_3_0
    coursier
    dotty
    eclipse-mat
    kotlin
    kotlin-native
    ktlint
    openjdk17
    mill
    sbt
    scala
    scalafmt
    scalafix
    visualvm
    # other
    flutter
    go_1_17
  ];

  environment = {
    etc = {
      "jdk8".source = pkgs.openjdk8;
      "jdk11".source = pkgs.openjdk11;
      "jdk17".source = pkgs.openjdk17;
    };

    variables = {
      EDITOR = mkOverride 900 "${pkgs.vim}/bin/vim";
    };
  };

  programs.adb.enable = true;

  virtualisation.docker = {
    enable = true;
    enableNvidia = true;
  };

  virtualisation.libvirtd.enable = true;
  
  virtualisation.virtualbox = {
    host.enable = true;
    host.enableHardening = true;
    host.enableExtensionPack = true;
    host.package = pkgs.virtualbox;
  };

  users.users.kj = {
    extraGroups = [ "adbusers" "docker" "kvm" "libvirtd" "vboxusers" ];
    packages = with pkgs; [
      python3Packages.arelle-headless 
    ];
  };  

  users.users.kjw = {
    extraGroups = [ "docker" "vboxusers" ];
    packages = with pkgs; [
      adcolony.paas-nextgen
      apacheKafka
      awscli
      aws-vault
      cassandra
      kafkacat
      slack
      unstable.kubernetes
      unstable.kubernetes-helm
      unstable.lens
      zoom-us
    ];
  };

  virtualisation.oci-containers.containers.data-science = {
    cmd = [
      "jupyter-notebook"
      "--no-browser"
      "--ip=127.0.0.1"
      "--notebook-dir=/tmp/dev"
      "--NotebookApp.token=''"
    ];
    extraOptions = [
      "--network=host"
    ];
    image = "kjanosz/data-science";
    log-driver = "journald";
    user = "1000:100";
    volumes = [
      "/home/kj/Dev:/tmp/dev"
    ];
    workdir = "/tmp/dev";
  };
  systemd.services."${ociBackend}-data-science" = {
    partOf = [ "user@1000.service" ];
    wantedBy = [ "user@1000.service" ];
  };
}  

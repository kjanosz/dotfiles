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
    arion
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
    # ide
    unstable.jetbrains.idea-community
    vim
    vscode
    # haskell
    cabal2nix
    cabal-install
    ghc
    # unstable.haskellPackages.apply-refact
    # unstable.haskellPackages.brittany
    # unstable.haskellPackages.HaRe
    # idris
    idris
    # lisp
    racket
    # proof
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
    ammonite_2_12
    ammonite_2_13
    ammonite_3_0
    coursier
    dotty
    openjdk11
    mill
    sbt
    scala
    visualvm
  ];

  environment = {
    etc = {
      "jdk8".source = pkgs.openjdk8;
      "jdk11".source = pkgs.openjdk11;
      "jdk16".source = pkgs.unstable.openjdk16;
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
      wireshark
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
      jq
      kafkacat
      openvpn
      slack
      unstable.kubernetes
      unstable.kubernetes-helm
      unstable.lens
      vagrant
      wireshark
      zoom-us
    ];
  };

  services.openvpn.servers.adcolony = {
    autoStart = false;
    config = "config /var/lib/openvpn/adcolony.ovpn";
    updateResolvConf = true;
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

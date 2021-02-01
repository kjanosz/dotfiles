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
    unstable.idea.idea-community
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
    ammonite2_12
    ammonite2_13
    coursier
    dotty
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

  virtualisation.docker = {
    enable = true;
    enableNvidia = true;
  };

  virtualisation.libvirtd.enable = true;
  
  virtualisation.virtualbox = {
    host.enable = true;
    host.enableHardening = true;
    host.enableExtensionPack = true;
    host.package = pkgs.unstable.virtualbox;
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
      awscli
      aws-vault
      jq
      kafkacat
      openvpn
      slack
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
      "/home/kj/.local/share/jupyter:/.local/share/jupyter"
    ];
    workdir = "/tmp/dev";
  };
  systemd.services."${ociBackend}-data-science" = {
    partOf = [ "user@1000.service" ];
    wantedBy = [ "user@1000.service" ];
  };
}  

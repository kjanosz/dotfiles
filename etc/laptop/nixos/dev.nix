{ config, lib, pkgs, ... }:

with lib;

let
  editorScript = pkgs.writeScriptBin "emacseditor" ''
    #!${pkgs.stdenv.shell}
    if [ -z "$1" ]; then
      exec ${pkgs.emacs}/bin/emacsclient --create-frame --alternate-editor ${pkgs.emacs}/bin/emacs
    else
      exec ${pkgs.emacs}/bin/emacsclient --alternate-editor ${pkgs.emacs}/bin/emacs "$@"
    fi
  '';

  pythonEnv = pkgs.python3.withPackages (ps: with ps; [ 
    jupyter_core jupyter_client jupyterlab jupyterlab_launcher notebook ipython ipykernel
  ]);
in
{
  environment.pathsToLink = [
    "/lib/summon/"
  ];

  environment.systemPackages = with pkgs; [
    # general
    ack
    ag
    dbeaver
    docker_compose
    gcc
    gdb
    gnumake
    insomnia
    summon
    # ide
    editorScript
    emacs
    unstable.idea.idea-community
    vscode
    # haskell
    cabal2nix
    cabal-install
    ghc
    haskell-ide-engine
    unstable.haskellPackages.apply-refact
    unstable.haskellPackages.brittany
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
    rustChannels.stable
    rustfmt
    rustracer
    rustup
    # scala & jvm
    ammonite2_12
    ammonite2_13
    coursier
    mill
    openjdk
    sbt
    scala
    visualvm
    # data science
    julia_11
    nbstripout
    pythonEnv
  ];

  environment.variables = {
    EDITOR = mkOverride 900 "${editorScript}/bin/emacseditor";
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
      wireshark
    ];
  };  

  users.users.kjw = {
    extraGroups = [ "docker" "vboxusers" ];
    packages = with pkgs; [
      ansible
      awscli
      aws-vault
      unstable.flyway
      go
      mysql
      nailgun
      nodejs
      unstable.packer
      unstable.slack
      albacross.summon-aws-secrets
      albacross.terraform
    ];
  };

  systemd.user.services.emacs = {
    wantedBy = [ "default.target" ];
    
    path = [ pkgs.gnupg ];
    script = ''
      export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
      exec "$SHELL" --login -c "exec ${pkgs.emacs}/bin/emacs --daemon"
    '';
    serviceConfig = {
      Type = "forking";
      ExecStop = "${pkgs.emacs}/bin/emacsclient --eval (kill-emacs)";
      Restart = "always";
    };
  };

  docker-containers.kaggle-python = {
    cmd = [
      "jupyter-notebook"
      "--no-browser" 
      "--ip=127.0.0.1"
      "--notebook-dir=/tmp/kaggle"
      "--NotebookApp.token=''"
    ];
    extraDockerOptions = [
      "--network=host"
    ];
    image = "gcr.io/kaggle-images/python";
    log-driver = "journald";
    user = "1000:100";
    volumes = [
      "/home/kj/Dev/kaggle:/tmp/kaggle"
      "/home/kj/.local/share/jupyter:/.local/share/jupyter"
    ];
    workdir = "/tmp/kaggle";
  };
  systemd.services.docker-kaggle-python = {
    partOf = [ "user@1000.service" ];
    wantedBy = [ "user@1000.service" ];
  };
}  

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

  summonWithGopass = pkgs.summon.withPlugins { providers = [ pkgs.gopass ]; };

  pythonEnv = pkgs.python3.withPackages (ps: with ps; [ 
    jupyter_core jupyter_client jupyterlab jupyterlab_launcher notebook ipython ipykernel
  ]);
in
{
  environment.systemPackages = with pkgs; [
    # general
    dbeaver
    docker_compose
    insomnia
    summonWithGopass
    # toolchain
    ack
    ag
    gcc
    gdb
    gnumake
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
    # scala & JVM
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
}  

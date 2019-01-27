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
    # coq
    coq
    # haskell
    cabal2nix
    cabal-install
    ghc
    haskell-ide-engine
    haskellPackages.apply-refact
    haskellPackages.brittany
    # haskellPackages.HaRe
    # idris
    idris
    # julia & python
    julia_10
    python36Packages.jupyter_core
    python36Packages.jupyter_client
    python
    # purescript
    #unstable.purescript
    # racket
    racket
    # rust
    carnix
    rustChannels.stable
    rustfmt
    rustracer
    rustup
    # scala & JVM
    ammonite2_11
    ammonite2_12
    coursier
    mill
    openjdk
    sbt
    scala
    visualvm
  ];

  environment.variables = {
    EDITOR = mkOverride 900 "${editorScript}/bin/emacseditor";
  };

  programs.adb.enable = true;

  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableHardening = true;

  users.users.kj = {
    extraGroups = [ "adbusers" "docker" "vboxusers" ];
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

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
in
{
  environment.systemPackages = with pkgs; [
    # general
    bazel
    dbeaver
    docker_compose
    insomnia
    # toolchain
    ack
    ag
    gcc
    gnumake
    # ide
    editorScript
    emacs
    idea.idea-community
    vscode
    # coq
    coq
    # haskell
    cabal2nix
    cabal-install
    ghc
    haskell-ide-engine
    haskellPackages.structured-haskell-mode
    # idris
    haskellPackages.idris
    # rust
    rustChannels.stable
    rustfmt
    rustracer
    # scala & JVM
    ammonite2_11
    ammonite2_12
    coursier
    mill
    openjdk
    sbt
    scala
    visualvm
    # python
    python
    # racket
    racket
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
      gopass
      summon
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

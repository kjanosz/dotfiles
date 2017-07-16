{ config, lib, utils, pkgs, pkgs_unstable, ... }:

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
    editorScript
    emacs
    pkgs_unstable.idea.idea-community
    ack
    ag
    gcc
    gnumake
    elixir
    cabal-install
    ghc
    haskellPackages.structured-haskell-mode
    stack
    haskellPackages.idris
    cargo
    rustc
    rustfmt
    rustracer
    ammonite2_10
    ammonite2_11
    ammonite2_12
    clojure
    openjdk
    sbt
    scala
    scalafmt
    visualvm
    python
    pkgs_unstable.python27Packages.tensorflow
    racket
  ];

  environment.variables = {
    EDITOR = lib.mkOverride 900 "${editorScript}/bin/emacseditor";
  };

  systemd.user.services.emacs = {
    wantedBy = [ "default.target" ];
    after = [ "gnupg.service" ];
    
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

  virtualisation.docker.enable = true;
  virtualisation.rkt.enable = true;
  virtualisation.virtualbox.host.enable = true;
}  

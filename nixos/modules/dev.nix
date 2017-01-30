{ config, lib, utils, pkgs, ... }:

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

  environment.variables = {
    EDITOR = lib.mkOverride 900 "${editorScript}/bin/emacseditor";
  };

  systemd.user.services.emacs = {
    path = [ pkgs.gnupg ];
    preStart = ''
      gpgconf --create-socketdir
      gpg-connect-agent /bye > /dev/null 2>&1
    '';
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
  virtualisation.virtualbox.host.enable = true;
}  

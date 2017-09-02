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

  mozillaOverlays =
    let
      version = "7e54fb37cd177e6d83e4e2b7d3e3b03bd6de0e0f";
    in
      fetchTarball "https://github.com/mozilla/nixpkgs-mozilla/archive/${version}.tar.gz";

   rustOverlay = builtins.toPath (lib.concatStrings [ mozillaOverlays "/rust-overlay.nix" ]);
in
{
  nixpkgs.overlays = [ (import rustOverlay) ];
  nixpkgs.config.packageOverrides = pkgs: with pkgs; {
    ammonite2_10 = callPackage ../pkgs/ammonite { scala = "2.10"; };
    ammonite2_11 = callPackage ../pkgs/ammonite { scala = "2.11"; };
    ammonite2_12 = callPackage ../pkgs/ammonite { scala = "2.12"; };

    inherit (pkgs_unstable) coursier;
  };

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
    pkgs_unstable.rustc
    pkgs_unstable.rustfmt
    pkgs_unstable.rustracer
    ammonite2_10
    ammonite2_11
    ammonite2_12
    clojure
    coursier
    openjdk
    sbt
    scala
    visualvm
    python
    pkgs_unstable.python27Packages.tensorflow
    racket
    nodePackages.node2nix
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

{ fetchFromGitHub, lib, makeWrapper, pkgs, stdenv, ... }:

with lib;

let
  dotfiles = builtins.fetchGit {  
    url = "https://github.com/kjanosz/dotfiles";
    ref = "master";
  };
in
{
  i3-lock-screen = stdenv.mkDerivation rec {
    name = "i3-lock-screen-${version}";
    version = "${dotfiles.shortRev}";
    src = dotfiles;

    buildInputs = [ makeWrapper ];
    installPhase = ''
      mkdir -p $out/bin
      cp $src/home/default/bin/.local/bin/i3-lock-screen $out/bin
    '';
    postInstall = with pkgs; ''
      wrapProgram $out/bin/i3-lock-screen --prefix PATH ':' \
        ${makeBinPath [ findutils i3lock procps xorg.setxkbmap ]}
    '';
  };

  i3-merge-configs = stdenv.mkDerivation rec {
    name = "i3-merge-configs-${version}";
    version = "${dotfiles.shortRev}";
    src = dotfiles;

    buildInputs = [ makeWrapper ];
    installPhase = ''
      mkdir -p $out/bin
      cp $src/home/default/bin/.local/bin/i3-merge-configs $out/bin
    '';
    postInstall = with pkgs; ''
      wrapProgram $out/bin/i3-merge-configs --prefix PATH ':' \
        ${makeBinPath [ coreutils findutils ]}
    '';
  };
}

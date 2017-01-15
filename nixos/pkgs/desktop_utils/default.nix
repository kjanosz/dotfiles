{ fetchFromGitHub, lib, makeWrapper, pkgs, stdenv, ... }:

with lib;

let
  version = "git-20170115";
  dotfiles = fetchFromGitHub {
    owner = "kjanosz";
    repo = "dotfiles";
    rev = "146e7be5a38ccd161854318bdaa22d82e5c5ea28";
    sha256 = "0aslp6s1aqq771wdd8q43idyaysdlknd4nw76ab30jgqf8agj441";
  };
in
{
  i3-lock-screen = stdenv.mkDerivation rec {
    name = "i3-lock-screen-${version}";
    src = dotfiles;

    buildInputs = [ makeWrapper ];
    installPhase = ''
      mkdir -p $out/bin
      cp $src/.local/bin/i3-lock-screen $out/bin
    '';
    postInstall = with pkgs; ''
      wrapProgram $out/bin/i3-lock-screen --prefix PATH ':' \
        ${makeBinPath [ findutils i3lock procps xorg.setxkbmap ]}
    '';
  };

  i3-merge-configs = stdenv.mkDerivation rec {
    name = "i3-merge-configs-${version}";
    src = dotfiles;

    buildInputs = [ makeWrapper ];
    installPhase = ''
      mkdir -p $out/bin
      cp $src/.local/bin/i3-merge-configs $out/bin
    '';
    postInstall = with pkgs; ''
      wrapProgram $out/bin/i3-merge-configs --prefix PATH ':' \
        ${makeBinPath [ coreutils findutils ]}
    '';
  };
}

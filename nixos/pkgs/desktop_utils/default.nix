{ fetchFromGitHub, lib, makeWrapper, pkgs, stdenv, ... }:

with lib;

let
  gitVersion = "git-20170709";
  dotfiles = fetchFromGitHub {
    owner = "kjanosz";
    repo = "dotfiles";
    rev = "05ad48d8d612249ba251542c758455e51f7d6b49";
    sha256 = "0vxz4k02a9gnan11s7mjlw3yyyqibb0gp8b8fphjamd2v8h0ljd9";
  };
in
{
  i3-lock-screen = stdenv.mkDerivation rec {
    name = "i3-lock-screen-${version}";
    version = gitVersion;
    src = dotfiles;

    buildInputs = [ makeWrapper ];
    installPhase = ''
      mkdir -p $out/bin
      cp $src/default/bin/.local/bin/i3-lock-screen $out/bin
    '';
    postInstall = with pkgs; ''
      wrapProgram $out/bin/i3-lock-screen --prefix PATH ':' \
        ${makeBinPath [ findutils i3lock procps xorg.setxkbmap ]}
    '';
  };

  i3-merge-configs = stdenv.mkDerivation rec {
    name = "i3-merge-configs-${version}";
    version = gitVersion;
    src = dotfiles;

    buildInputs = [ makeWrapper ];
    installPhase = ''
      mkdir -p $out/bin
      cp $src/default/bin/.local/bin/i3-merge-configs $out/bin
    '';
    postInstall = with pkgs; ''
      wrapProgram $out/bin/i3-merge-configs --prefix PATH ':' \
        ${makeBinPath [ coreutils findutils ]}
    '';
  };
}

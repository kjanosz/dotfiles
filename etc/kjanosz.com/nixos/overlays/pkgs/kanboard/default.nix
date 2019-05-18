{ stdenv, fetchFromGitHub, pkgs
, appConfig ? null
, stateDir ? "/var/www/kanboard"
, plugins ? []
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "kanboard";
  version = "1.2.7";

  src = fetchFromGitHub {
    owner = "kanboard";
    repo = "kanboard";
    rev = "v${version}";
    sha256 = "0jg3av7r5v25dkxxyx5lp0cwvvpj25hvpfrj57azhc2h61psqn1r";
  };

  buildInputs = [ pkgs.unzip ];

  installPhase = ''
    rm config.default.php
    rm web.config
    rm -rf data

    mkdir -p $out/bin
    cp -r * $out
    ${optionalString (!isNull appConfig) "ln -s ${appConfig} $out/config.php"}

    ${concatMapStringsSep "\n" (p: ''
      mkdir -p $out/plugins/${p.dest}
      ln -s ${p.src}/* $out/plugins/${p.dest}
    '') plugins}

    ln -s ${stateDir} $out/data
  '';
}

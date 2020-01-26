{ stdenv, pythonPackages, mopidy, writeTextFile }:


let
  mopidy-dbus = writeTextFile {
    name = "mopidy-dbus";
    text = builtins.readFile ./dbus.conf;
  };
in
pythonPackages.buildPythonApplication rec {
  pname = "Mopidy-MPRIS";
  version = "2.0.0";

  src = pythonPackages.fetchPypi {
    inherit pname version;
    sha256 = "15ymsh4lvimq6g9chhpkx5f41q16qv8pb68p8vf5v83zaqrcid7k";
  };

  propagatedBuildInputs = [
    mopidy
  ] ++ (with pythonPackages; [
    pydbus
    pykka
  ]);

  doCheck = false;

  postInstall = ''
    install -Dm644 ${mopidy-dbus} $out/etc/dbus-1/system.d/org.mpris.MediaPlayer2.mopidy.conf
  '';
}

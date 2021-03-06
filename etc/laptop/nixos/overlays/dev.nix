self: super:

with super.lib;

let
  mozillaOverlays = builtins.fetchGit {  
    url = "https://github.com/mozilla/nixpkgs-mozilla";
    ref = "master";
  };
in
foldlExtensions [
  (import (mozillaOverlays + "/rust-overlay.nix"))
  
  (self: super: rec {
    ammonite_2_12 = super.callPackage pkgs/ammonite { scala = "2.12"; };

    ammonite_2_13 = super.callPackage pkgs/ammonite { scala = "2.13"; };

    ammonite_3_0 = super.callPackage pkgs/ammonite { scala = "3.0"; };

    mill = super.callPackage pkgs/mill { };

    nbstripout = with super.python3Packages; buildPythonApplication rec {
      name = "${pname}-${version}";
      pname = "nbstripout";
      version = "0.3.7";

      src = fetchPypi {
        inherit pname version;
        sha256 = "1x6010akw7iqxn7ba5m6malfr2fvaf0bjp3cdh983qn1s7vwlq0r";
      };
      
      buildInputs = [ pytestrunner ];
      propagatedBuildInputs = [ ipython nbformat ];
      doCheck = false;
    };

    rustChannels = {
      stable = (super.rustChannelOf { date = "2021-06-17"; channel = "stable"; }).rust;

      beta = (super.rustChannelOf { date = "2021-07-04"; channel = "beta"; }).rust;

      nightly = (super.rustChannelOf { date = "2021-07-11"; channel = "nightly"; }).rust;
    };

    scala = super.scala.override { jre = super.openjdk11; };

    sbt = super.sbt.override { jre = super.openjdk11; };

    sbt8 = super.sbt.override { jre = super.openjdk8; };

    summon = super.unstable.summon;

    vscode = super.callPackage pkgs/vscode { pkgs = super.unstable; };
  })
] self super

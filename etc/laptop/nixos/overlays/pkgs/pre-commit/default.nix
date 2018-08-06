{ lib, pkgs, python27, python27Packages,  ... }:

let
  aspy_yaml = python27.pkgs.buildPythonPackage rec {
    pname = "aspy.yaml";
    version = "1.0.0";
    name = "${pname}-${version}";

    pythonPath = with python27Packages; [ pyyaml ];
    
    src = python27.pkgs.fetchPypi {
      inherit pname version;
      sha256 = "152apndxdssgzl634xykdr1pcqljlw36p8q0pmyz4rgz014z85b2";
    };

    doCheck = false;
  };

  cfgv = python27.pkgs.buildPythonPackage rec {
    pname = "cfgv";
    version = "1.0.0";
    name = "${pname}-${version}";

    pythonPath = with python27Packages; [ six ];
    
    src = python27.pkgs.fetchPypi {
      inherit pname version;
      sha256 = "1ib0b5g1bmfrj1bavq4dhs781f8h2rbnlcvis8ray1jidgva4fkk";
    };

    doCheck = false;
  };

  identify = python27.pkgs.buildPythonPackage rec {
    pname = "identify";
    version = "1.0.8";
    name = "${pname}-${version}";

    pythonPath = [];
    
    src = python27.pkgs.fetchPypi {
      inherit pname version;
      sha256 = "18ascdw4v4riwwy9wghzxbb31bcxzxddbqmfaj7dwk706jbb5gy0";
    };

    doCheck = false;
  };

  nodeenv = python27.pkgs.buildPythonPackage rec {
    pname = "nodeenv";
    version = "1.2.0";
    name = "${pname}-${version}";

    pythonPath = [ ];
    
    src = python27.pkgs.fetchPypi {
      inherit pname version;
      sha256 = "1pqqr3jrj601hla3j3xnmxfaaxv7vgik8wncx89sg53zfammv0wq";
    };

    doCheck = false;
  };

  precommit = python27.pkgs.buildPythonApplication rec {
    pname = "pre_commit";
    version = "1.8.2";
    name = "${pname}-${version}";

    pythonPath = with python27Packages; [ aspy_yaml cfgv cached-property identify nodeenv six pyyaml virtualenv  ];

    src = python27.pkgs.fetchPypi {
      inherit pname version;
      sha256 = "1fvbmnz9p2s36r6llmdpimq7h9ssgyx4f2gkkx505yx978b54d42";
    };
  };
in
pkgs.buildEnv {
    name = "precommit-${precommit.version}";
    paths = lib.closePropagation (with python27Packages; [ nodeenv virtualenv ]);
    pathsToLink = [ "/${python27.sitePackages}" ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      makeWrapper ${precommit}/bin/pre-commit $out/bin/pre-commit \
        --prefix PYTHONPATH : $out/${python27.sitePackages}
    '';
}

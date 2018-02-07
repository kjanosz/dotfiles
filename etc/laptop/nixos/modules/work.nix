{ config, lib, utils, pkgs, ... }:

let
  pre_commit = pkgs.python27.pkgs.buildPythonApplication rec {
    pname = "pre_commit";
    version = "1.6.0";
    name = "${pname}-${version}";

    pythonPath = with pkgs.python27Packages; [ aspy_yaml cached-property identify nodeenv six pyyaml virtualenv  ];

    src = pkgs.python27.pkgs.fetchPypi {
      inherit pname version;
      sha256 = "0zz77jddmpbgy6plfl3jg7q977dq2ck5l7fnkif7qrwhlgslcrkd";
    };
  };

  aspy_yaml = pkgs.python27.pkgs.buildPythonPackage rec {
    pname = "aspy.yaml";
    version = "1.0.0";
    name = "${pname}-${version}";

    pythonPath = with pkgs.python27Packages; [ pyyaml ];
    
    src = pkgs.python27.pkgs.fetchPypi {
      inherit pname version;
      sha256 = "152apndxdssgzl634xykdr1pcqljlw36p8q0pmyz4rgz014z85b2";
    };

    doCheck = false;
  };

  identify = pkgs.python27.pkgs.buildPythonPackage rec {
    pname = "identify";
    version = "1.0.7";
    name = "${pname}-${version}";

    pythonPath = with pkgs.python27Packages; [ ];
    
    src = pkgs.python27.pkgs.fetchPypi {
      inherit pname version;
      sha256 = "0x6dl3nrznbqc00s60rzl7zhp0k0nhfy1q209176d220kk73qva9";
    };

    doCheck = false;
  };

  nodeenv = pkgs.python27.pkgs.buildPythonPackage rec {
    pname = "nodeenv";
    version = "1.2.0";
    name = "${pname}-${version}";

    pythonPath = with pkgs.python27Packages; [ ];
    
    src = pkgs.python27.pkgs.fetchPypi {
      inherit pname version;
      sha256 = "1pqqr3jrj601hla3j3xnmxfaaxv7vgik8wncx89sg53zfammv0wq";
    };

    doCheck = false;
  };

  blessclient = pkgs.python27.pkgs.buildPythonApplication rec {
    name = "blessclient-${version}";
    version = "778094a";

    pythonPath = with pkgs.python27Packages; [ boto3 psutil kmsauth six tkinter docutils ];

    src = pkgs.fetchgit {
      url = "https://github.com/lyft/python-blessclient";
      sha256 = "06ppp90w03win1zmjvin82p5zvag5vjbv3kd52zspad10wg4kpwh";
      rev = "778094a49e13d85a3a51d886f2506ae172d34b7b";
    };
  };

  kmsauth = pkgs.python27.pkgs.buildPythonPackage rec {
    pname = "kmsauth";
    version = "0.3.0";
    name = "${pname}-${version}";

    pythonPath = with pkgs.python27Packages; [ boto3 docutils ];
    
    src = pkgs.python27.pkgs.fetchPypi {
      inherit pname version;
      sha256 = "1kxb6v0fm91n0qmbyj024172j4j2axdr4jq51cf2fabc47gyja14";
    };

    doCheck = false;
  };
in 
{
  users.extraUsers.kjw.packages = with pkgs; [
    awscli
    blessclient
    cookiecutter
    docker_compose
    docker-machine
    nailgun
    pre_commit
    shfmt
    terraform_0_11
    travis
    zoom-us
  ];
}

{ config, lib, utils, pkgs, ... }:

let
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
    shfmt
    terraform_0_11
    travis
    zoom-us
  ];
}

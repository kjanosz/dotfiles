{ fetchFromGitHub, python27, python27Packages, ... }:

let
  kmsauth = python27Packages.buildPythonPackage rec {
    pname = "kmsauth";
    version = "0.3.0";
    name = "${pname}-${version}";

    pythonPath = with python27Packages; [ boto3 docutils ];
    
    src = python27Packages.fetchPypi {
      inherit pname version;
      sha256 = "1kxb6v0fm91n0qmbyj024172j4j2axdr4jq51cf2fabc47gyja14";
    };

    doCheck = false;
  };
in 
python27Packages.buildPythonApplication rec {
  name = "blessclient-${version}";
  version = "778094a";

  pythonPath = with python27Packages; [ boto3 psutil kmsauth six tkinter docutils ];

  src = fetchFromGitHub {
    owner = "lyft";
    repo = "python-blessclient";
    rev = "778094a49e13d85a3a51d886f2506ae172d34b7b";
    sha256 = "06ppp90w03win1zmjvin82p5zvag5vjbv3kd52zspad10wg4kpwh";
  };
}

{ fetchFromGitHub, python27, python27Packages, ... }:

let
  kmsauth = python27Packages.buildPythonPackage rec {
    pname = "kmsauth";
    version = "0.3.0";
    name = "${pname}-${version}";

    pythonPath = with python27Packages; [ boto3 ];
    
    src = python27Packages.fetchPypi {
      inherit pname version;
      sha256 = "1kxb6v0fm91n0qmbyj024172j4j2axdr4jq51cf2fabc47gyja14";
    };

    doCheck = false;
  };
in # 2018-10-04T07:24:39+10:00
python27Packages.buildPythonApplication rec {
  name = "blessclient-${version}";
  version = "HEAD";

  pythonPath = with python27Packages; [ boto3 psutil kmsauth six hvac ];

  src = fetchFromGitHub {
    owner = "lyft";
    repo = "python-blessclient";
    rev = "0bdv9b8l62njl39wn3wyhwqsfph0c7sjdjsb8k2aqw94a7zkd2gr";
    sha256 = "";
  };
}

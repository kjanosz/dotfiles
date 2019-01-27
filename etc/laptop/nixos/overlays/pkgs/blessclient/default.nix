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
in # 2018-12-12T10:47:22-08:00
python27Packages.buildPythonApplication rec {
  name = "blessclient-${version}";
  version = "HEAD";

  pythonPath = with python27Packages; [ boto3 psutil kmsauth six hvac ];

  src = fetchFromGitHub {
    owner = "lyft";
    repo = "python-blessclient";
    rev = "a8a896c2285a2bfb6314b5c60f673b5812198ef7";
    sha256 = "0blgaipyh6nabh6c2jhkyjbga847gn6zsrqrf59k6qj415rip322";
  };
}

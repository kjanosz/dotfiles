{ lib, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  pname = "beancount_interpolate";
  version = "2.3.2";

  src = pythonPackages.fetchPypi {
    inherit pname version;
    sha256 = "1y5n75y3y77rl1yr5q8xgslxvffyxbznbnl7w420lvllm9jykwqc";
  };

  propagatedBuildInputs = [
    pythonPackages.beancount
    pythonPackages.beancount_plugin_utils
  ];

  doCheck = false;
}

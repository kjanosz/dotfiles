{ lib, pythonPackages  }:

pythonPackages.buildPythonPackage rec {
  pname = "beancount_plugin_utils";
  version = "0.0.4";

  src = pythonPackages.fetchPypi {
    inherit pname version;
    sha256 = "12kpb856ljw0z6cq9lxilsqf9ag0ix1nh8dzbljg9k7kzpg83mz9";
  };

  propagatedBuildInputs = [
    pythonPackages.beancount
  ];

  doCheck = false;
}

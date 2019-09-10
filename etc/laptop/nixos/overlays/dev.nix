self: super:

with super.lib;

let
  mozillaOverlays = builtins.fetchGit {  
    url = "https://github.com/mozilla/nixpkgs-mozilla";
    ref = "master";
  };

  hies = import (builtins.fetchGit {
    url = "https://github.com/Infinisil/all-hies";
    ref = "master";
  }) {};
in
foldlExtensions [
  (import (mozillaOverlays + "/rust-overlay.nix"))
  
  (self: super: rec {
    ammonite2_12 = super.callPackage pkgs/ammonite { scala = "2.12"; };

    ammonite2_13 = super.callPackage pkgs/ammonite { scala = "2.13"; };

    emacs = super.callPackage pkgs/emacs { pkgs = super.unstable; };

    haskell-ide-engine = hies.selection { selector = p: { inherit (p) ghc865 ghc844 ghc822; }; };

    mill = super.callPackage pkgs/mill { };

    nbstripout = with super.python3Packages; buildPythonApplication rec {
      name = "${pname}-${version}";
      pname = "nbstripout";
      version = "0.3.6";

      src = fetchPypi {
        inherit pname version;
        sha256 = "1x6010akw7iqxn7ba5m6malfr2fvaf0bjp3cdh983qn1s7vwlq0r";
      };
      
      buildInputs = [ pytestrunner ];
      propagatedBuildInputs = [ ipython nbformat ];
      doCheck = false;
    };

    rustChannels = {
      stable = (super.rustChannelOf { date = "2019-08-15"; channel = "stable"; }).rust;

      beta = (super.rustChannelOf { date = "2019-09-04"; channel = "beta"; }).rust;

      nightly = (super.rustChannelOf { date = "2019-09-08"; channel = "nightly"; }).rust;
    };

    summon = super.callPackage pkgs/summon { };

    terraform-provider-vultr = super.callPackage pkgs/terraform-provider-vultr { };

    vscode = super.callPackage pkgs/vscode { pkgs = super.unstable; };
  })
] self super

self: super:

with super.lib;

let
  # 2019-04-02T09:39:52+02:00
  mozillaOverlays = configFromGitHubOf {  
    owner = "mozilla";
    repo = "nixpkgs-mozilla";
    rev = "50bae918794d3c283aeb335b209efd71e75e3954";
    sha256 = "07b7hgq5awhddcii88y43d38lncqq9c8b2px4p93r5l7z0phv89d";
  };

  # 2019-05-15T23:52:25+02:00
  hies = super.fetchFromGitHub {
    owner = "Infinisil";
    repo = "all-hies";
    rev = "777b6665c1671feaa3c3eb74d10dd6f79ec1302c";
    sha256 = "03py0j4d6asrxmp1170n5sywsa2y1pw0xr51r2f1digfg5ryrw98";
  };
in
foldlExtensions [
  (import (mozillaOverlays + "/rust-overlay.nix"))
  
  (self: super: rec {
    ammonite2_11 = super.callPackage pkgs/ammonite { scala = "2.11"; };

    ammonite2_12 = super.callPackage pkgs/ammonite { scala = "2.12"; };

    emacs = super.callPackage pkgs/emacs { pkgs = super.unstable; };

    haskell-ide-engine = (import hies{ }).selection { selector = p: { inherit (p) ghc864 ghc844 ghc822; }; };

    mill = super.callPackage pkgs/mill { };

    rustChannels = {
      stable = (super.rustChannelOf { date = "2019-05-14"; channel = "stable"; }).rust;

      beta = (super.rustChannelOf { date = "2019-05-17"; channel = "beta"; }).rust;

      nightly = (super.rustChannelOf { date = "2019-05-18"; channel = "nightly"; }).rust;
    };

    summon = super.callPackage pkgs/summon { };

    terraform-provider-vultr = super.callPackage pkgs/terraform-provider-vultr { };

    vscode = super.callPackage pkgs/vscode { pkgs = super.unstable; };
  })
] self super

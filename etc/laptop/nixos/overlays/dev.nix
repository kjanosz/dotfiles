self: super:

with super.lib;

let
  # 2018-09-06T17:09:51+02:00
  mozillaOverlays = configFromGitHubOf {  
    owner = "mozilla";
    repo = "nixpkgs-mozilla";
    rev = "136eacc0ceefa8fb44677799e5639e083606ee5d";
    sha256 = "04bz093x3zjkzp7ba8mh876a1a34kp3jrys87m79gbln5qvcd2ir";
  };

  # 2018-07-21T20:31:03+01:00
  hie-nix = super.fetchFromGitHub {
    owner = "domenkozar";
    repo = "hie-nix";
    rev = "e3113da93b479bec3046e67c0123860732335dd9";
    sha256 = "05rkzjvzywsg66iafm84xgjlkf27yfbagrdcb8sc9fd59hrzyiqk";
  };
in
foldlExtensions [
  (import (mozillaOverlays + "/rust-overlay.nix"))
  
  (self: super: rec {
    ammonite2_11 = super.callPackage pkgs/ammonite { scala = "2.11"; };

    ammonite2_12 = super.callPackage pkgs/ammonite { scala = "2.12"; };

    emacs = super.callPackage pkgs/emacs { pkgs = super.unstable; };

    haskell-ide-engine = (import hie-nix { }).hies;

    mill = super.callPackage pkgs/mill { };

    rustChannels = {
      stable = (super.rustChannelOf { date = "2018-09-25"; channel = "stable"; }).rust;

      beta = (super.rustChannelOf { date = "2018-10-05"; channel = "beta"; }).rust;

      nightly = (super.rustChannelOf { date = "2018-10-07"; channel = "nightly"; }).rust;
    };

    summon = super.callPackage pkgs/summon { };

    terraform-provider-vultr = super.callPackage pkgs/terraform-provider-vultr { };

    vscode = super.callPackage pkgs/vscode { pkgs = super.unstable; };
  })
] self super

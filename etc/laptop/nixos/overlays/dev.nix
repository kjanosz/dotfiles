self: super:

with super.lib;

let
  # 2018-10-30T22:11:41-04:00
  mozillaOverlays = configFromGitHubOf {  
    owner = "mozilla";
    repo = "nixpkgs-mozilla";
    rev = "0d64cf67dfac2ec74b2951a4ba0141bc3e5513e8";
    sha256 = "0ngj2rk898rq73rq2rkwjax9p34mjlh3arj8w9npwwd6ljncarmh";
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
      stable = (super.rustChannelOf { date = "2018-11-08"; channel = "stable"; }).rust;

      beta = (super.rustChannelOf { date = "2018-11-09"; channel = "beta"; }).rust;

      nightly = (super.rustChannelOf { date = "2018-11-10"; channel = "nightly"; }).rust;
    };

    summon = super.callPackage pkgs/summon { };

    terraform-provider-vultr = super.callPackage pkgs/terraform-provider-vultr { };

    vscode = super.callPackage pkgs/vscode { pkgs = super.unstable; };
  })
] self super

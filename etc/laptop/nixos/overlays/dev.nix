self: super:

with super.lib;

let
  # 2019-01-25T17:40:39+01:00
  mozillaOverlays = configFromGitHubOf {  
    owner = "mozilla";
    repo = "nixpkgs-mozilla";
    rev = "507efc7f62427ded829b770a06dd0e30db0a24fe";
    sha256 = "17p1krbs6x6rnz59g46rja56b38gcigri3h3x9ikd34cxw77wgs9";
  };

  # 2019-01-02T17:40:22+00:00
  hie-nix = super.fetchFromGitHub {
    owner = "domenkozar";
    repo = "hie-nix";
    rev = "19f47e0bf2e2f1a793bf87d64bf8266062f422b1";
    sha256 = "1px146agwmsi0nznc1zd9zmhgjczz6zlb5yf21sp4mixzzbjsasq";
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
      stable = (super.rustChannelOf { date = "2019-01-17"; channel = "stable"; }).rust;

      beta = (super.rustChannelOf { date = "2019-01-25"; channel = "beta"; }).rust;

      nightly = (super.rustChannelOf { date = "2019-01-25"; channel = "nightly"; }).rust;
    };

    summon = super.callPackage pkgs/summon { };

    terraform-provider-vultr = super.callPackage pkgs/terraform-provider-vultr { };

    vscode = super.callPackage pkgs/vscode { pkgs = super.unstable; };
  })
] self super

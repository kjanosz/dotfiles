self: super:

with super.lib;

let
  # 2018-08-02T19:51:22+02:00
  mozillaOverlays = configFromGitHubOf {  
    owner = "mozilla";
    repo = "nixpkgs-mozilla";
    rev = "cf7bc3ac8c482461d9df1b799b80ee79911af85b";
    sha256 = "09fqb1hiw82ymcdy18qkwvxddhqg2y3gyqki4crm2jb664yzvx3j";
  };

  # 2018-06-11T15:48:27+02:00
  hie-nix = super.fetchFromGitHub {
    owner = "domenkozar";
    repo = "hie-nix";
    rev = "e3113da93b479bec3046e67c0123860732335dd9";
    sha256 = "05rkzjvzywsg66iafm84xgjlkf27yfbagrdcb8sc9fd59hrzyiqk";
  };
in
foldlExtensions [
  (import (mozillaOverlays + "/rust-overlay.nix"))
  
  (self: super: {
    ammonite2_11 = self.callPackage pkgs/ammonite { scala = "2.11"; };

    ammonite2_12 = self.callPackage pkgs/ammonite { scala = "2.12"; };

    bazel = super.unstable.bazel;

    dbeaver = super.unstable.dbeaver;

    emacs = self.callPackage pkgs/emacs { pkgs = super.unstable; };

    gopass = super.unstable.gopass;

    haskell-ide-engine = (import hie-nix { }).hies;

    idea = super.unstable.idea;

    insomnia = super.unstable.insomnia;

    mill = self.callPackage pkgs/mill { };

    rustChannels = {
      stable = (super.rustChannelOf { date = "2018-08-02"; channel = "stable"; }).rust;

      beta = (super.rustChannelOf { date = "2018-08-01"; channel = "beta"; }).rust;

      nightly = (super.rustChannelOf { date = "2018-08-03"; channel = "nightly"; }).rust;
    };

    summon = self.callPackage pkgs/summon { };

    vscode = self.callPackage pkgs/vscode { pkgs = super.unstable; };
  })
] self super

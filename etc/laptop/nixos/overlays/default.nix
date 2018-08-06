self: super:

let
  lib = import ../lib.nix super;
in with lib;
foldlExtensions [
  (self: super: {
    lib = super.lib // lib;
  })

  (self: super: {  
    # 2018-08-01T22:32:51+08:00
    unstable = nixpkgsOf {
      repo = "nixpkgs-channels";
      rev = "2428f5dda13475afba2dee93f4beb2bd97086930";
      sha256 = "1iwl5yaz36lf7v4hps3z9dl3zyq363jmr5m7y4anf0lpn4lczh18";
    };
  })

  (self: super: {
    base16-builder = self.callPackage ./pkgs/base16-builder { };

    calibre = super.calibre.overrideAttrs (oldAttrs: {
      buildInputs = oldAttrs.buildInputs ++ [ super.python27Packages.dns ];
    });

    desktop_utils = self.callPackage ./pkgs/desktop_utils { };

    firefox = super.unstable.wrapFirefox (super.unstable.firefox-unwrapped) {
      extraNativeMessagingHosts = [ super.unstable.browserpass ];
    };

    pass = super.unstable.pass;
  })

  (import ./dev.nix)
  
  (import ./coya.nix)
] self super

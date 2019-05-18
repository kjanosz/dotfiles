{ lib, ... }:

rec {
  foldlExtensions = overlays: self: super:
    lib.foldl' (lib.flip lib.extends) (lib.const super) overlays self;

  configOf = { url, sha256 }:
    builtins.fetchTarball {
      inherit url sha256;
    };

  configFromGitHubOf = { rev, sha256, owner ? "NixOS", repo ? "nixpkgs" }:
    configOf {
      url = "https://github.com/${owner}/${repo}/archive/${rev}.tar.gz";

      inherit sha256;
    };

  nixpkgsOf = { rev, sha256, config ? { allowUnfree = true; }, owner ? "NixOS", repo ? "nixpkgs-channels" }:
    let pkgs = configFromGitHubOf { inherit owner repo rev sha256; };
    in (import pkgs { inherit config; }) // {
      preventGC = pkgs.writeTextDir "prevent-ifd-gc" (toString [ pkgs ]);
    };

  pkgOf = { pkg, rev, sha256, config ? { allowUnfree = true; }, owner ? "NixOS", repo ? "nixpkgs-channels" }:
    let pkgs = configFromGitHubOf { inherit owner repo rev sha256; };
    in (pkg (import pkgs { inherit config; })).overrideAttrs (oldAttrs: {
         postInstall = (oldAttrs.postInstall or "") + ''
           echo ${pkgs} >$out/prevent-ifd-gc
         '';
       });

  moduleOf = { url, sha256, path, base, overwrite ? false }:
    {    
      disabledModules = if (overwrite) then [ "${path}" ] else [];

      imports = [ (import (configOf { inherit url sha256; } + "/${base}/${path}")) ];
    };

  moduleFromGitHubOf = { path, rev, sha256, owner ? "NixOS", repo ? "nixpkgs", base ? "nixos/modules/", overwrite ? false }:
    moduleOf {
      url = "https://github.com/${owner}/${repo}/archive/${rev}.tar.gz";

      inherit sha256 path base overwrite;
    };
}

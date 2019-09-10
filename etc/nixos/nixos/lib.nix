{ lib, ... }:

let
  moduleOf = { base, path, overwrite ? false }:
    {    
      disabledModules = if (overwrite) then [ "${base}/${path}" ] else [];

      imports = [ (import path) ];
    };
in rec {
  foldlExtensions = overlays: self: super:
    lib.foldl' (lib.flip lib.extends) (lib.const super) overlays self;

  nixpkgsFromGitHubOf = { url, ref, rev ? "HEAD", config ? { allowUnfree = true; } }:
    let pkgs = builtins.fetchGit { inherit url ref rev; };
    in (import pkgs { inherit config; }) // {
      preventGC = pkgs.writeTextDir "prevent-ifd-gc" (toString [ pkgs ]);
    };

  moduleFromTarballOf = { url, sha256, path, base ? "", overwrite ? false }:
    {    
      disabledModules = if (overwrite) then [ "${path}" ] else [];

      imports = [ (import (builtins.fetchTarball { inherit url sha256; } + "${base}/${path}")) ];
    };

  moduleFromGitHubOf = { path, rev, sha256, owner ? "NixOS", repo ? "nixpkgs", base ? "nixos/modules/", overwrite ? false }:
    moduleFromTarballOf {
      url = "https://github.com/${owner}/${repo}/archive/${rev}.tar.gz";

      inherit sha256 path base overwrite;
    };
}

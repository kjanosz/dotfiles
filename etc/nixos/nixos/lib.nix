{ pkgs, ... }:

rec {
  nixpkgsOf = { rev, sha256, config, owner ? "NixOS", repo ? "nixpkgs" }:
    (import (pkgs.fetchFromGitHub {
      owner = owner;
      repo = repo;

      inherit rev sha256;
    }) { inherit config; }).pkgs;

  moduleFromGitHubOf = { path, rev, sha256, owner ? "NixOS", repo ? "nixpkgs" }: moduleOf {
    url = "https://raw.githubusercontent.com/${owner}/${repo}/${rev}/nixos/modules/${path}";
    overwrites = path;
    
    inherit sha256;
  };

  moduleOf = { url, sha256, overwrites ? null }:
    let
      module = import (import <nix/fetchurl.nix> {
        url = url;
          
        inherit sha256;
      });
    in
    {    
      disabledModules = if (overwrites != null) then [ "${overwrites}" ] else [];
    
      imports = [ module ];
    };
}

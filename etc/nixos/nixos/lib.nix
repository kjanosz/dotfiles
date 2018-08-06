{ lib, fetchFromGitHub, ... }:

with lib;

with {
  ifThenElse = { bool, thenValue, elseValue }: (
    if bool then thenValue else elseValue);

  system = builtins.currentSystem;  
};

rec {
  foldlExtensions = overlays: self: super:
   foldl' (flip extends) (const super) overlays self;

  configOf = { url, sha256 }:
    ifThenElse {
      bool = (0 <= builtins.compareVersions builtins.nixVersion "1.12");

      # In Nix 1.12, we can just give a `sha256` to `builtins.fetchTarball`.
      thenValue = (
        builtins.fetchTarball {
          inherit url sha256;
        });

      # This hack should at least work for Nix 1.11
      elseValue = (
        (rec {
          tarball = import <nix/fetchurl.nix> {
            inherit url sha256;
          };

          builtin-paths = import <nix/config.nix>;

          script = builtins.toFile "nixpkgs-unpacker" ''
            "$coreutils/mkdir" "$out"
            cd "$out"
            "$gzip" --decompress < "$tarball" | "$tar" -x --strip-components=1
          '';

          nixpkgs = builtins.derivation {
            name = "nixpkgs-${sha256}";

            builder = builtins.storePath builtin-paths.shell;

            args = [ script ];

            inherit tarball system;

            tar       = builtins.storePath builtin-paths.tar;
            gzip      = builtins.storePath builtin-paths.gzip;
            coreutils = builtins.storePath builtin-paths.coreutils;
          };
        }).nixpkgs);
    };

  configFromGitHubOf = { rev, sha256, owner ? "NixOS", repo ? "nixpkgs" }:
    configOf {
      url = "https://github.com/${owner}/${repo}/archive/${rev}.tar.gz";
      inherit sha256;
    };

  nixpkgsOf = { rev, sha256, config ? { allowUnfree = true; }, owner ? "NixOS", repo ? "nixpkgs" }:    
    (import (fetchFromGitHub {
      inherit owner repo rev sha256;
    }) { inherit config; }).pkgs;

  pkgOf = { path, rev, sha256, config ? { allowUnfree = true; }, owner ? "NixOS", repo ? "nixpkgs" }:
    path (nixpkgsOf {
      inherit rev sha256 config owner repo;
    });

  moduleFromGitHubOf = { path, rev, sha256, owner ? "NixOS", repo ? "nixpkgs", base ? "nixos/modules/", overwrite ? false }:
    moduleOf {
      url = "https://github.com/${owner}/${repo}/archive/${rev}.tar.gz";

      inherit sha256 path basePath overwrite;
    };

  moduleOf = { url, sha256, path, base ? "nixos/modules/", overwrite ? false }:
    {    
      disabledModules = if (overwrite) then [ "${path}" ] else [];

      imports = [ (import (configOf { inherit url sha256; } + "/${basePath}/${path}")) ];
    };
}

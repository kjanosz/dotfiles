{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.nix;

  channelSubmodule = { options, ... }:
  {
    options = {
      address = mkOption {
        type = types.str;
      };
      name = mkOption {
        type = types.str;
      };
      path = mkOption {
        type = types.str;
      };
    };
  };

  basePath = "/nix/var/nix/profiles/per-user/root/channels";

  channelPath = c: builtins.toPath "${basePath}/${c.name}/nixpkgs";

  channelExprs = c: "${c.address}/nixexprs.tar.xz";

  channelPkgs = n: c:
    let
      imported = builtins.tryEval (import (channelPath c) {
        config = config // {
          allowUnfree = config.nixpkgs.config.allowUnfree;
        };
      });
    in
      if (imported.success) then imported.value
      else (import (fetchTarball (channelExprs c)) {
        config = config // {
          allowUnfree = config.nixpkgs.config.allowUnfree;
        };  
      });

  addChannel = n: c: ''
    if [ ! -d "${basePath}/${c.name}" ]; then
      sudo nix-channel --add ${c.address} ${c.name}
      sudo nix-channel --update ${c.name}
    fi
  '';

  refreshChannel = n: c:
    if c.name != "nixos" then "sudo nix-channel --update ${c.name}" else "";

  addChannelsScript = pkgs.writeScript "nixos-rebuild-all" ''
    #!${pkgs.bash}/bin/bash
  
    ${concatStringsSep "\n" (mapAttrsToList addChannel cfg.channels)}

    for i in "$@" ; do
      if [[ $i == "--upgrade" ]] ; then
        ${concatStringsSep "\n" (mapAttrsToList refreshChannel cfg.channels)}
        break
      fi
    done

    sudo nixos-rebuild "$@"
  '';
  
  channelNixPath = n: c:
    let
      path = channelPath c;
    in
      if builtins.pathExists path then "${c.path}=${path}" else "${c.path}=${channelExprs c}";
in
{
  options = {
    nix = {
      channels = mkOption {
        type = types.attrsOf (types.submodule (channelSubmodule));
      };
    };
  };

  config = {
    _module.args = mapAttrs channelPkgs cfg.channels;
  
    environment.shellAliases = {
      nixos-rebuild = "${addChannelsScript}";
    };
  
    nix.nixPath = (mapAttrsToList channelNixPath cfg.channels) ++ [     
      "nixos-config=/etc/nixos/configuration.nix"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];
  };
}

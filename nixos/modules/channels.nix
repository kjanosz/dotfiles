{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.nix.channels;

  basePath = "/nix/var/nix/profiles/per-user/root/channels";
  
  allChannels = cfg.additional // {
    "nixpkgs" = {
      address = cfg.base;
      name = "nixos";
    };
  };

  savedChannels = let
    channelsFile = (builtins.getEnv "HOME") + "/.nix-channels";
    channels = splitString "\n" (lib.removeSuffix "\n" (builtins.readFile channelsFile));
    channelAttr = ch:
      let
        kv = splitString " " ch;
      in
        if builtins.length kv == 2
        then nameValuePair (builtins.elemAt kv 1) (builtins.elemAt kv 0)
        else {};
  in
    builtins.listToAttrs (filter (ch: ch != {}) (map channelAttr channels));

  channelPath = c: builtins.toPath "${basePath}/${c.name}/nixpkgs";

  channelExprs = c: "${c.address}/nixexprs.tar.xz";

  channelPkgs = n: c:
    let
      name =
        if n == "nixpkgs" then "pkgs"
        else "pkgs_" + (builtins.replaceStrings ["-"] ["_"] (removePrefix "nixpkgs-" n));
      
      packages = { system ? builtins.currentSystem }:
        let
          args = {
            system = system;
            config = config // {
              allowUnfree = config.nixpkgs.config.allowUnfree or false;
            };
          };
        
          imported = builtins.tryEval (import (channelPath c) args);
        in
          if (imported.success)
          then imported.value
          else (import (fetchTarball (channelExprs c)) args);
    in 
      if builtins.currentSystem == "i686-linux" then [ (nameValuePair name (packages {})) ]
      else [
        (nameValuePair name (packages {}))
        (nameValuePair (name + "_i686") (packages { system = "i686-linux"; })) 
      ];
      
  channelNixPath = n: c:
    let
      path = channelPath c;
      channelExists = savedChannels ? ${c.name} && savedChannels.${c.name} == c.address;
    in
      if builtins.pathExists path && channelExists
      then "${n}=${path}"
      else "${n}=${channelExprs c}";    
      
  nixos-rebuild = pkgs.writeScriptBin "nixos-rebuild" ''
    #!${pkgs.bash}/bin/bash

    declare -A currentChannels
    while read l; do
      t=($l)
      if [ "''${#t[@]}" -eq "2" ]; then
        currentChannels["''${t[0]}"]="''${t[1]}"
      fi
    done < <(nix-channel --list)

    upgrade=0
    for arg in "$@"; do
      shift
      if [ "$arg" == "--upgrade" ]; then
        upgrade=1
      else
        set -- "$@" "$arg"  
      fi  
    done

    channels=()
    ${concatMapStringsSep "\n" (c: ''
      if [ ! -d "${basePath}/${c.name}" ] ||
         [ "''${currentChannels["${c.name}"]}" != "${c.address}" ]; then
        nix-channel --add ${c.address} ${c.name}
        channels+="${c.name} "
      elif [ $upgrade -eq 1 ]; then
        channels+="${c.name} "
      fi
    '') (builtins.attrValues allChannels)}
    
    if [ ! -z "$channels" ]; then
      nix-channel --update $channels      
    fi
    
    ${config.system.build.nixos-rebuild}/bin/nixos-rebuild "$@"
  '';
in
{
  options = {
    nix = {
      channels = mkOption {
        type = types.submodule {
          options = {          
            base = mkOption {
              type = types.nullOr types.str;
              default = null;
            };

            additional = mkOption {
              type = types.attrsOf (types.submodule {
                options = {    
                  address = mkOption {
                    type = types.str;
                  };
                  name = mkOption {
                    type = types.str;
                  };
                };
              });
              default = {};
            };
          };
        };  
      };
    };
  };

  config = mkIf (cfg.base != null) {
    _module.args = listToAttrs (flatten (mapAttrsToList channelPkgs allChannels));

    nix.nixPath = (mapAttrsToList channelNixPath allChannels) ++ [     
      "nixos-config=/etc/nixos/configuration.nix"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];

    environment.systemPackages = [ nixos-rebuild ];
    
    systemd.services.nixos-upgrade.script = mkForce ''
      ${nixos-rebuild}/bin/nixos-rebuild switch --no-build-output --upgrade
    '';
  };
}

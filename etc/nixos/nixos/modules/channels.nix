{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.nix.channels;
  
  allChannels = (mapAttrs (n: c: c // { name = "nixos-${n}"; }) cfg.additional) // {
    "nixpkgs" = {
      address = cfg.base;
      name = "nixos";
    };
  };

  channelName = c: builtins.replaceStrings ["nixos"] ["nixpkgs"] c.name;

  channelPath = c: builtins.toPath "${cfg.path}/${c.name}/nixpkgs";

  channelExprs = c: "${c.address}/nixexprs.tar.xz";

  channelPkgs = n: c:
    let
      name =
        if n == "nixpkgs" then "pkgs"
        else "pkgs_" + (builtins.replaceStrings ["-"] ["_"] n);
      
      packages = { system ? builtins.currentSystem }:
        let
          args = {
            system = system;
            config = config // {
              allowUnfree = config.nixpkgs.config.allowUnfree or false;
            };
          };

          path = channelPath c;
        
          imported = builtins.tryEval (import path args);
        in
          if ((builtins.pathExists path) && imported.success)
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
      name = channelName c;
      path = channelPath c;
    in
      if builtins.pathExists path
      then "${name}=${path}"
      else "${name}=${channelExprs c}";    
      
  nixos-rebuild = pkgs.writeScriptBin "nixos-rebuild" ''
    #!${pkgs.bash}/bin/bash

    mkdir -p ${cfg.path}
    
    upgrade=0
    for arg in "$@"; do
      shift
      if [ "$arg" == "--upgrade" ]; then
        upgrade=1
      else
        set -- "$@" "$arg"  
      fi  
    done

    GLOBIGNORE=()
    ${concatMapStringsSep "\n" (c: ''
      if [ ! -d "${cfg.path}/${c.name}" ] ||
         [ $upgrade -eq 1 ]; then
         rm -rf ${cfg.path}/${c.name}
         ln -s ${fetchTarball (channelExprs c)} ${cfg.path}/${c.name}
      fi
      GLOBIGNORE=$GLOBIGNORE:${cfg.path}/${c.name}
    '') (builtins.attrValues allChannels)}
    rm -rf ${cfg.path}/* #*/
    unset GLOBIGNORE
       
    ${config.system.build.nixos-rebuild}/bin/nixos-rebuild "$@"
  '';

  nix-env = pkgs.writeScriptBin "nix-env" ''
    #!${pkgs.bash}/bin/bash
    
    ${pkgs.nix}/bin/nix-env -f ${cfg.path} "$@"
  '';
in
{
  options = {
    nix = {
      channels = mkOption {
        type = types.submodule {
          options = {
            path = mkOption {
              type = types.path;
              default = "/nix/var/nixpkgs";
            };
           
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
      "${cfg.path}"
    ];

    environment.systemPackages = [ nixos-rebuild nix-env ];
    
    systemd.services.nixos-upgrade.script = mkForce ''
      ${nixos-rebuild}/bin/nixos-rebuild switch --no-build-output --upgrade
    '';
  };
}

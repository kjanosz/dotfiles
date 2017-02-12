{ config, lib, pkgs, makeWrapper, ... }:

with lib;

let
  cfg = config.nix;

  basePath = "/nix/var/nix/profiles/per-user/root/channels";

  allChannels = cfg.channels.additional // {
    "nixpkgs" = {
      address = cfg.channels.base;
      name = "nixos";
    };
  };

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
          if (imported.success) then imported.value
          else (import (fetchTarball (channelExprs c)) args);
    in 
      if builtins.currentSystem == "i686-linux" then [ (nameValuePair name (packages {})) ]
      else [
        (nameValuePair name (packages {}))
        (nameValuePair (name + "_i686") (packages { system = "i686-linux"; })) 
      ];

  addChannel = n: c: ''
    if [ ! -d "${basePath}/${c.name}" ]; then
      nix-channel --add ${c.address} ${c.name}
      nix-channel --update ${c.name}
    fi
  '';

  refreshChannel = n: c:
    if c.name != "nixos" then "nix-channel --update ${c.name}" else "";
  
  channelNixPath = n: c:
    let
      path = channelPath c;
    in
      if builtins.pathExists path then "${n}=${path}" else "${n}=${channelExprs c}";

  nixos-rebuild = pkgs.writeScriptBin "nixos-rebuild" ''
    #!/bin/sh
  
    ${concatStringsSep "\n" (mapAttrsToList addChannel allChannels)}

    for i in "$@" ; do
      if [[ $i == "--upgrade" ]] ; then
        ${concatStringsSep "\n" (mapAttrsToList refreshChannel allChannels)}
        break
      fi
    done

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
              type = types.str;
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

  config = {
    _module.args = listToAttrs (flatten (mapAttrsToList channelPkgs allChannels));
  
    nix.nixPath = (mapAttrsToList channelNixPath allChannels) ++ [     
      "nixos-config=/etc/nixos/configuration.nix"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];

    environment.systemPackages = [ nixos-rebuild ];

    system.build.nixos-rebuild = nixos-rebuild;
  };
}

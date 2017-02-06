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
      autoUpdate = mkOption {
        type = types.bool;
        default = true;
      };
    };
  };

  basePath = "/nix/var/nix/profiles/per-user/root/channels";

  addChannel = n: c: ''
    if [ ! -d "${basePath}/${c.name}" ]; then
      sudo nix-channel --add ${c.address} ${c.name}
      sudo nix-channel --update ${c.name}
    fi
  '';

  refreshChannel = n: c: if c.name != "nixos" then "sudo nix-channel --update ${c.name}" else "";

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
  
  channelNixPath = n: c: [
    "${n}=${basePath}/${c.name}/nixpkgs" 
    "${n}=${c.address}/nixexprs.tar.xz"
  ];
  
  channelsNixPath = flatten (mapAttrsToList channelNixPath cfg.channels);
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
    environment.shellAliases = {
      nixos-rebuild = "${addChannelsScript}";     
    };
  
    nix.nixPath = channelsNixPath ++ [     
      "nixos-config=/etc/nixos/configuration.nix"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];
  };
}

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.gnupg.profiles;

  allProfiles = cfg.additional // {
    "default" = cfg.default;
  };

  profileDir = "/share/gnupg/profiles";
  
  gpg-switch = pkgs.writeScriptBin "gpg-switch" ''
    #!${pkgs.bash}/bin/bash

    BASE_PATH="/run/current-system/sw${profileDir}"
    PROFILE="default"
    RELOAD=true

    OPTIONS=lp:r
    LONGOPTIONS=list,profile:,reload

    # -temporarily store output to be able to check for errors
    # -activate advanced mode getopt quoting e.g. via “--options”
    # -pass arguments only via   -- "$@"   to separate them correctly
    PARSED=$(${pkgs.utillinux}/bin/getopt --options=$OPTIONS --longoptions=$LONGOPTIONS --name "$0" -- "$@")
    if [[ $? -ne 0 ]]; then
        # e.g. $? == 1
        #  then getopt has complained about wrong arguments to stdout
        exit 2
    fi
    # use eval with "$PARSED" to properly handle the quoting
    eval set -- "$PARSED"

    # now enjoy the options in order and nicely split until we see --
    while true; do
        case "$1" in
            -l|--list)
                find $BASE_PATH -iname "*.prf" -exec basename -s ".prf" '{}' \; | sort
                exit 0
                ;;
            -p|--profile)
                PROFILE="$2"
                shift 2
                ;;
            -r|--reload)
                RELOAD=true
                shift
                ;;
            --)
                shift
                break
                ;;
            *)
                echo "Programming error"
                exit 3
                ;;
        esac
    done

    if [ -e "$BASE_PATH/$PROFILE.prf" ]; then
      ${pkgs.gnupg}/bin/gpgconf --apply-profile "$BASE_PATH/$PROFILE.prf" > /dev/null 2>&1
      if [ "$RELOAD" = true ]; then
        ${pkgs.gnupg}/bin/gpgconf --reload
      fi
    else
      echo "Profile $PROFILE does not exist"
      exit 1
    fi
  '';

  writeProfile = n: p:
    pkgs.writeTextFile {
      name = "gpg-profile-${n}";
      destination = "/${profileDir}/${n}.prf";
      text = ''
        ${optionalString (p.gpg-agent != null) ''
          [gpg-agent]
          ${p.gpg-agent}
        ''}
        ${optionalString (p.scdaemon != null) ''
          [scdaemon] 
          ${p.scdaemon}
        ''}
      '';  
    };

  writtenProfiles = mapAttrsToList writeProfile allProfiles;
      
  profile = {
    options = {
      gpg-agent = mkOption {
        type = types.nullOr types.lines;
        default = null;
      };

      scdaemon = mkOption {
        type = types.nullOr types.lines;
        default = null;
      };
    };
  };
in
{
  options = {
    services.gnupg.profiles = mkOption {
      type = types.submodule {
        options = {
          default = mkOption {
            type = types.nullOr (types.submodule profile);
            default = null;
          };

          additional = mkOption {
            type = types.nullOr (types.attrsOf (types.submodule profile));
            default = null;
          };
        };
      };
    };
  };

  config = mkIf (cfg.default != null) {
    environment.pathsToLink = [ profileDir ];
        
    environment.systemPackages = [ gpg-switch ] ++ writtenProfiles;

    systemd.user.services.gnupg = {
      wantedBy = [ "default.target" ];
      
      serviceConfig = {
        Type = "forking";
        Restart = "always";
        KillSignal = "SIGKILL";
        ExecPreStart = "${gpg-switch}/bin/gpg-switch -p default";
        ExecStart = "${pkgs.gnupg}/bin/gpgconf --launch gpg-agent";
        ExecStop = "S{pkgs.gnupg}/bin/gpgconf --kill gpg-agent";
      };
    };
  };
}

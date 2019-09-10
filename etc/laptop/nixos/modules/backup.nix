{ config, lib, utils, pkgs, ... }:

with lib;

# UrBackup
let
  cfg = config.backup;
  
  backupVolume = n: c:
  let
    dump = cmd: xs: concatMapStringsSep " " (x: "${cmd} ${x}") xs;
  
    content =
      if (c.excludes == [] and c.includes []) then ""
      else concatStringsSep " " [ (dump "--include" c.includes) (dump "--exclude" c.excludes) ];

    options = null;
  in
  ''
    TARGET="file:///backup/${n}"
  
    function createSnapshot {
      lvcreate -L512M -s -n ${n}-backup /dev/${c.group}/${n}
      mkdir -p /mnt/snapshot/${n}
      mount /dev/${c.group}/${n}-backup /mnt/snapshot/${n} -o ro
    }

    function cleanOldBackup {
      ${if !isNull c.cleanOlderThan then "duplicity remove-older-than ${OLDER_THAN} $TARGET" else ""}
    }
      
    function makeBackup {
      duplicity --encrypt-key "${cfg.encKeyId}" --full-if-older-than ${c.fullBackupFrequency} ${content} /mnt/snapshot/${n} $TARGET
    }
    
    function removeSnapshot {
      unmount /mnt/snapshot/${n}
      lvremove -f /dev/${c.group}/{n}-backup
    }

    cleanOldBackup
    createSnapshot
    makeBackup
    trap removeSnapshot EXIT
  '';
in
{

  options = {
    backup = {
      volumes = mkOption {
        type = types.attrs (types.submodule {
          options = {
            group = mkOption {
              type = types.string;
              default = "nixos";

              description = "LVM volume group";
            };

            backupFrequency = mkOption {
              type = types.string;

              descriptiom = "Backup frequency in systemd interval format";
            };

            excludes = mkOption {
              type = types.listOf types.string;
              default = [ "**" ];

              description = "Directories to exclude from backup";
            };

            includes = mkOption {
              type = types.listOf types.string;
              default = [];

              description = "Directories to include in backup";
            };
          };
        });
        default = {};
      };

      targets = mkOption {
        type = types.attrs (types.submodule {
          base = mkOption {
            type = types.string;

            description = "Base path including schema for the duplicity target";
          };

          envFile = mkOption {
            type = types.nullOr types.path;
            default = null;

            description = "Path to the file containing all environment variables needed for the target";
          };
        
          options = mkOption {
            type = types.listOf types.string;
            default = [];

            description = "List of options for the duplicity target";
          };

          encryptKeyId = mkOption {
            type = types.nullOr types.string;
            default =  default;

            description = "Key id used for the encryption";
          };     

          signKeyId = mkOption {
            type = types.bool;
            default = false;

            description = "Key id used for the signing";
          };

          backupFrequency = mkOption {
            type = types.nullOr types.string;
            default = null;

            descriptiom = "Backup frequency in systemd interval format";
          };

          fullBackupAfter = mkOption {
            type = types.string;

            description = "Interval in duplicity format between each full backup";
          };

          cleanOlderThan = mkOption {
            type = types.nullOr types.string;
            default = null;

            description = "Delete old backups after interval specified in duplicity format";
          };
        });
        default = [];

        description = "List of duplicity targets";
      };
    };
  };

  config = mkIf (cfg.volumes != {}) {
    environment.etc."lvm/lvm.conf".text = ''
      snapshot_autoextend_threshold = 70
      snapshot_autoextend_percent = 50
    '';
  
    environment.systemPackages = with pkgs; [
      borg
      rclone
    ];


    systemd.services = mapAttrs' (n: c: nameValuePair
      ("backup-${n}")
      ({
        description = "";
        serviceConfig = {
          Type = "oneshot";
          PrivateTmp = true;
        };
        path = [ pkgs.duplicity pkgs.lvm ];
        script = backupVolume n c;
      } // (
        if (isNull c.envFile) then {}
        else { EnvironmentFile = c.envFile; }
      ))
    );

    systemd.timers = mapAttrs' (n: c: nameValuePair
      ("backup-${n}")
      ({
        description = "Backup ${n} volume on specific frequency";
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = c.backupFrequency;
          Unit = "backup-${n}.service";
          Persistent = "yes";
          AccuracySec = "3m";
          RandomizedDelaySec = "30m";
        };
      })
    ) (filterAttrs (n: c: !isNull c.backupFrequency) cfg.volumes);
  };
}

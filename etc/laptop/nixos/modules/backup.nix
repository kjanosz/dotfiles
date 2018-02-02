{ config, lib, utils, pkgs, ... }:

let
  cfg = config.backup;
  
  backupVolume = n: c: ''
    function createSnapshot {
      lvcreate -Lx -s -n ${n}-backup /dev/${c.group}/${n}
      mkdir -p /mnt/snapshot/${n}
      mount /dev/${c.group}/${n}-backup /mnt/snapshot/${n} -o ro
    };

    function makeBackup {
      duplicity --encrypt-key "${cfg.encKeyId}" /mnt/snapshot/${n}
    };
    
    function removeSnapshot {
      unmount /mnt/snapshot/${n}
      lvremove /dev/${c.group}/{n}-backup
    };

    createSnapshot
    makeBackup
    trap removeSnapshot EXIT
  '';
in
{
  options = {
    backup = {
      encKeyId = mkOption {
        type = types.string;
      };
      
      volumes = mkOption {
        type = types.attrs (types.submodule {
          options = {
            group = mkOption {
              type = types.string;
              default = "nixos";
            };
            
            frequency = mkOption {
              type = types.string;
            };
          };
        });
        default = {};
      };
    };
  };

  config = mkIf (cfg.volumes != {}) {
    environment.systemPackages = with pkgs; [
      duplicity
    ];

    mapAttrs (n: c: ) cfg.volumes

    systemd.services.backup = {
      
    };

    systemd.timers.backup = {

    };
  };
}

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.beanstalkd;
  user = "beanstalkd";
  params = concatStringsSep " " [
    "-l ${cfg.address}"
    "-p ${toString cfg.port}"
    "-u ${user}"
    (optionalString (!isNull cfg.dataDir) "-b ${cfg.dataDir}")
    (if (isNull cfg.fsync) then "-F" else "-z ${cfg.fsync}")
    (if cfg.compactBinlog then "-c" else "-n")
    (optionalString (!isNull cfg.maxJobSize) "-z ${cfg.maxJobSize}")
    (optionalString (!isNull cfg.walSize) "-s ${cfg.walSize}")
  ];
in
{
  options = {
    services.beanstalkd = {
    
      enable = mkOption {
        type = types.bool;
        default = false;
      };

      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/beanstalkd";
      };

      address = mkOption {
        type = types.string;
        default = "127.0.0.1";
      };

      port = mkOption {
        type = types.int;
        default = 11300;
      };

      fsync = mkOption {
        type = types.nullOr types.int;
        default = null;
      };

      compactBinlog = mkOption {
        type = types.bool;
        default = true;
      };

      maxJobSize = mkOption {
        type = types.nullOr types.int;
        default = null;
      };

      walSize = mkOption {
        type = types.nullOr types.int;
        default = null;
      };
            
    };
  };

  config = mkIf cfg.enable {
    users.extraUsers.beanstalkd = {
      description = "Beanstalk work queue user";
      home = "${cfg.dataDir}";
      createHome = true;
      group = "beanstalkd";
      uid = 250;
    };

    users.extraGroups.beanstalkd.gid = 250;
  
    systemd.services.beanstalkd = {
      description = "Beanstalk work queue";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.beanstalkd ];
      preStart = optionalString (!isNull cfg.dataDir)''
        mkdir -p ${cfg.dataDir}
        chown -R ${user}:${user} ${cfg.dataDir}
      '';
      serviceConfig = {
        ExecStart = "${pkgs.beanstalkd}/bin/beanstalkd ${params}";
      };
    };
  };
}

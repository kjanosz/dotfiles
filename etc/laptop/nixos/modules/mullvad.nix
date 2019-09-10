{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.mullvad;
in
{
  options = {
    mullvad = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };

      package = mkOption {
        type = types.package;
        default = pkgs.mullvad;

        description = "Package for Mullvad VPN daemon";
      };

      socketPath = mkOption {
        type = types.path;
        
        description = "Socket path for Mullvad VPN daemon";
      };

      logDirectory = mkOption {
        type = types.path;
        
        description = "Log directory for Mullvad VPN daemon";
      };

      cacheDirectory = mkOption {
        type = types.path;
        
        description = "Cache directory for Mullvad VPN daemon";
      };
    };
  };

  config = mkIf (cfg.enable) {
    systemd.services.mullvad = {
      description = "Mullvad VPN daemon service";
      wants = [ "network.target" ];
      after = [ "network-online.target" "systemd-resolved.service" ];
      wantedBy = [ "multi-user.target" ];

      environment = lib.filterAttrs (k: v: v != null) {
        MULLVAD_LOG_DIR = cfg.logDirectory;
        MULLVAD_CACHE_DIR = cfg.cacheDirectory;
        MULLVAD_RPC_SOCKET_PATH = cfg.socketPath;
      };

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/mullvad-daemon -v --disable-stdout-timestamps";
        Restart = "always";
        RestartSec = 1;
        StartLimitBurst = 5;
        StartLimitIntervalSec = 20;
      };
    };
  };
}

{ config, lib, pkgs, ... }:

with pkgs;
with lib;

let
  cfg = services.postgresql.init;
in
{
  options = {
    services.postgresql.init = mkOption {
      type = types.nullOr (types.attrsOf types.lines);
      default = null;
    };
  };

  config = {
    services.postgresql = {
      enable = true;
      package = postgresql_11;
      port = 5432;
      dataDir = "/var/lib/postgresql/11.0";

      enableTCPIP = false;
      authentication = ''
        local   all   all                 trust
        host    all   all   127.0.0.1/32  trust
        host    all   all   0.0.0.0/0     reject
      '';

      extraPlugins = [
        pg_prometheus
        timescaledb
      ];
      extraConfig = ''
        shared_preload_libraries = 'pg_prometheus'
        shared_preload_libraries = 'timescaledb'
      '';
      initialScript = pkgs.writeText "psql-init" (if cfg != null then concatStringsSep "\n" (attrValues cfg) else "");
    };

    services.redis = {
      enable = true;
    };
  };
}
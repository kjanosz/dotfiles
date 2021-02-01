{ config, lib, pkgs, ... }:

with pkgs;
with lib;

let
  domain = config.networking.domain;

  subdomain = "cloud.${domain}";
in
{
  config = {
    services.nginx.virtualHosts."${subdomain}" = {
      forceSSL = true;
      useACMEHost = domain;
    };

    services.nextcloud = {
      enable = true;
      hostName = subdomain;
      nginx.enable = true;
      https = true;

      autoUpdateApps.enable = true;
      autoUpdateApps.startAt = "04:00:00";

      caching.redis = true;

      config = {
        overwriteProtocol = "https";

        dbtype = "pgsql";
        dbuser = "nextcloud";
        dbhost = "/run/postgresql";
        dbname = "nextcloud";
      };
    };

    services.postgresql.init.nextcloud = ''
      CREATE DATABASE nextcloud;
      CREATE USER nextcloud;
      GRANT ALL PRIVILEGES ON DATABASE nextcloud TO nextcloud;
    '';

    systemd.services."nextcloud-setup" = {
      requires = [ "postgresql.service" ];
      after = [ "postgresql.service" ];
    };
  };
}

{ config, lib, pkgs, ... }:

with pkgs;
with lib;

let
  domain = config.networking.domain;

  subdomain = "git.${domain}";

  gitea = config.services.gitea.package;
in
{
  config = {
    services.nginx.virtualHosts."${subdomain}" = {
      forceSSL = true;
      useACMEHost = domain;

      locations."/plantuml/" = {
        proxyPass = "http://localhost:8080";
      };

      locations."/" = {
        proxyPass = "http://localhost:3000";
      };
    };

    services.postgresql.init.gitea = ''
      CREATE DATABASE gitea;
      CREATE USER gitea;
      GRANT ALL PRIVILEGES ON DATABASE gitea TO gitea;
    '';

    services.gitea = {
      enable = true;

      rootUrl = "https://${subdomain}/";
      httpPort = 3000;
      cookieSecure = true;

      disableRegistration = true;

      database = {
        type = "postgres";
        name = "gitea";
        user = "gitea";
        socket = "/run/postgresql";
      };

      ssh = {
        enable = true;
      };

      settings = {
        cache = {
          ENABLED = true;
          ADAPTER = "redis";
          HOST = "${config.services.redis.unixSocket}";
        };

        mailer = {
          ENABLED = true;
          MAILER_TYPE = "sendmail";
          FROM = "git@kjanosz.com";
          SENDMAIL_PATH = "${pkgs.system-sendmail}/bin/sendmail";
        };
      };
    };

    systemd.services.gitea = {
      preStart = ''
        ${gitea}/bin/gitea migrate > /dev/null 2>&1
        ${gitea}/bin/gitea admin create-user --config /var/lib/gitea/custom/conf/app.ini --username kjanosz --email contact@kjanosz.com --admin --random-password --random-password-length 32 --must-change-password > /dev/null 2>&1 || true
      '';

      serviceConfig.SystemCallFilter = mkForce "~@clock @cpu-emulation @debug @keyring @memlock @module @mount @obsolete @raw-io @reboot @resources @swap";
    };

    virtualisation.oci-containers.containers.plant-uml = {
      autoStart = true;
      image = "plantuml/plantuml-server:tomcat-v1.2020.22";
      ports = [
        "8080:8080"
      ];
    };
  };
}

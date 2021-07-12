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

      locations."/" = {
        proxyPass = "http://localhost:3000";

        extraConfig = ''
          rewrite ^/.+/plantuml-images/([a-z0-9]*).svg$ /plantuml-images/$1.svg;
        '';
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
        "markup.markdown" = {
          ENABLED = true;                                                                                                         
          FILE_EXTENSIONS = ".md,.markdown";                                                                                                       
          RENDER_COMMAND = "pandoc -f markdown -t html --filter pandoc-plantuml";
        };
        
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
        mkdir -p /var/lib/gitea/custom/public && mkdir -p /var/lib/gitea/plantuml-images && ln -sf /var/lib/gitea/plantuml-images /var/lib/gitea/custom/public/.
      '';

      path = [ pandoc pandoc-plantuml-filter plantuml ];
      serviceConfig.SystemCallFilter = mkForce "~@clock @cpu-emulation @debug @keyring @memlock @module @mount @obsolete @raw-io @reboot @resources @swap";
    };
  };
}

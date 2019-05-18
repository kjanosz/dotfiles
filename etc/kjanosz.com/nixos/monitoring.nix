{ config, lib, pkgs, ... }:

with (import ./lib.nix { inherit lib; });

let
  alertmanager = moduleFromGitHubOf {
    path = "services/monitoring/prometheus/alertmanager.nix";
    rev = "f2a1a4e93be2d76720a6b96532b5b003cc769312";
    sha256 = "1yjk6ffnm6ahj34yy2q1g5wpdx0m1j7h8i4bzn4x78g9chb0ppy4";
    overwrite = true;
  };
  domain = "${config.networking.hostName}";
  secrets = import ./secrets.nix;
  collectdPort = 9103;
in 
{
  disabledModules = [ "services/monitoring/prometheus/default.nix" ];

  imports = [
    alertmanager
    ./modules/prometheus.nix
  ];

  config = {
    systemd.services.prometheus-postgresql-adapter = {
      wantedBy = [ "multi-user.target" ];
      after = [ "postgresql.service" "prometheus.service" ];

      path = [ pkgs.prometheus-postgresql-adapter ];

      serviceConfig = {
        User = "prometheus";
        Group = "prometheus";
        Restart = "always";
        ExecStart = "prometheus-postgresql-adapter -pg.user=monitoring -pg.password=monitoring -pg.database=monitoring -pg.schema=prometheus -pg.prometheus-normalized-schema=1 -pg.use-timescaledb=1";
      };
    };

    services.collectd = {
      enable = true;
      user = "root";

      extraConfig = ''
        Interval 10.0
        MaxReadInterval 60.0

        LoadPlugin write_prometheus
        <Plugin "write_prometheus">
          Port "${toString collectdPort}"
        </Plugin>

        LoadPlugin cpu
        <Plugin cpu>
          ReportByState true
          ReportByCpu true
          ValuesPercentage true
        </Plugin> 

        LoadPlugin df
        <Plugin "df">
          Device "/dev/vda"
          IgnoreSelected false
          ValuesAbsolute true
        </Plugin>   

        LoadPlugin disk
        <Plugin "disk">
          Disk "vda"
          IgnoreSelected false
        </Plugin>  

        LoadPlugin interface

        LoadPlugin load

        LoadPlugin memory
        
        LoadPlugin nginx
        <Plugin "nginx">
          URL "http://localhost:80/nginx_status"
        </Plugin>            

        LoadPlugin processes
        
        LoadPlugin swap
        
        LoadPlugin uptime
        
        LoadPlugin users
      '';
    };

    services.prometheus = {
      enable = true;
      package = pkgs.unstable.prometheus_2;

      configText = ''
        alerting:
          alertmanagers:
          - static_configs:
            - targets:
              - alertmanager:9093

        global:
          scrape_interval:     10s
          evaluation_interval: 10s
        
        remote_write:
        - url: "http://localhost:9201/write"
        remote_read:
        - url: "http://localhost:9201/read"
        
        scrape_configs:
        - job_name: collectd
          static_configs:
            - targets: ['localhost:${toString collectdPort}']
      '';

      alertmanager = {
        enable = true;
        package = pkgs.unstable.prometheus-alertmanager;

        listenAddress = "localhost";
        configText = ''
          global:
            smtp_smarthost: ${secrets.smtp.host}:${secrets.smtp.port};
            smtp_auth_username: ${secrets.smtp.user};
            smtp_auth_password: ${secrets.smtp.password};
            smtp_from: alerts@${domain};

          route:
            receiver: email
            group_wait: 30s
            group_interval: 5m
            repeat_interval: 3h
            group_by: [alertname, alias] 

          receivers:
          - name: email
            email_configs:
              - to: alerts@${domain}
        '';
      };
    };

    services.grafana = {
        enable = true;
        analytics.reporting.enable = false;

        domain = "monitoring.${domain}";
        rootUrl = "https://monitoring.${domain}/";

        database = {
          type = "postgres";
          host = "127.0.0.1:5432";
          name = "grafana";
          user = "grafana";
          password = "grafana";
        };

        security = {
          adminUser = "${secrets.monitoring.user}";
          adminPassword = "${secrets.monitoring.password}";
          secretKey = "${secrets.monitoring.secretKey}";
        };

        extraOptions = {
          session_provider = "redis";
          session_provider_config = "network=unix,addr=${config.services.redis.unixSocket},pool_size=10,db=grafana";
        };
    };

    services.nginx.virtualHosts = {
      "monitoring.${domain}" = {
        forceSSL = true;
        enableACME = true;
        
        locations."/" = {
          proxyPass = "http://${config.services.grafana.addr}:${toString config.services.grafana.port}";
        };
      };
    };

    services.postgresql.init = {
      grafana = ''
        CREATE ROLE grafana WITH LOGIN;
        CREATE DATABASE grafana OWNER grafana;
      '';

      monitoring = ''
        CREATE ROLE monitoring WITH LOGIN;
        CREATE DATABASE monitoring OWNER monitoring;
      '';
    };
  };
}

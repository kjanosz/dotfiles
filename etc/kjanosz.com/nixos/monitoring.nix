{ config, pkgs, ... }:

let
  domain = "${config.networking.hostName}";
  subdomain = "monitoring.${domain}";
  collectdPort = 9103;
  smtp = (import secrets.nix).smtp;
in 
{
  config = {
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
      package = pkgs.prometheus2;

      configText = ''
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
            - targets: ['localhost:${collectdPort}']
      '';

      alertmanagerURL = [ "http://localhost:9093" ];
      altertmanager = {
        enable = true;
        listenAddress = "localhost";
        configuration = {
          "global" = {
            "smtp_smarthost" = "${smtp.host}:${smtp.port}";
            "smtp_auth_username" = "${smtp.user}";
            "smtp_auth_password" = "${smtp.password}";
            "smtp_from" = "alerts@${domain}";
          };
          "route" = {
            "group_by" = [ 
              "alertname" 
              "alias"
            ];
            "group_wait" = "30s";
            "group_interval" = "5m";
            "repeat_interval" = "3h";
            "receiver" = "email";
          };
          "receivers" = [
            {
              "name" = "email";
              "email_configs" = [
                {
                  "from" = "alerts@${domain}";
                  "to" = "alerts@${domain}";
                  "send_resolved" = true;
                }
              ];
            }
          ];
        };
      };
    };

    services.grafana = {
        enable = true;
        domain = "${subdomain}";
        rootUrl = "https://${subdomain}/";
    };

    services.nginx.virtualHosts = {
      "${subdomain}" = {
        forceSSL = true;
        enableACME = true;
        
        locations."/" = {
          proxyPass = "http://${config.services.grafana.addr}:${toString config.services.grafana.port}";
        };
      };
    };
  };
}

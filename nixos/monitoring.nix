{ config, pkgs, ... }:

let
  influxDBCollectDPort = 25826;
  domain = "monitoring.${config.networking.hostName}";
  influxDBIncreasePatch = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/michalrus/dotfiles/master/.nixos-config.symlink/pkgs/influxdb/add_increase.patch";
    sha256 = "18m6gym4fl1a708zxprbgr6qz0c65maxxhmkcf6f1h5f43n0rz98";
  };
in 
{
  nixpkgs.config.packageOverrides = pkgs: with pkgs; {
    influxdb10 = (pkgs.stdenv.lib.overrideDerivation pkgs.influxdb (oldAttrs: {
      patches = [ influxDBIncreasePatch ];
    })).bin // { outputs = [ "bin" ]; };
  };

  services.influxdb = {
    enable = true;
    package = pkgs.influxdb10;
    extraConfig = {
      collectd = {
        enabled = true;
        typesdb = "${pkgs.collectd}/share/collectd/types.db";
        database = "collectd";
        port = influxDBCollectDPort;
      };
    };
  };

  services.collectd = {
    enable = true;

    user = "root";

    extraConfig = ''
      Interval 10.0
      MaxReadInterval 60.0

      LoadPlugin network
      <Plugin network>
        Server "localhost" "${toString influxDBCollectDPort}"
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

  services.grafana = {
      enable = true;
      domain = "${domain}";
      rootUrl = "https://${domain}/";
  };

  services.nginx.virtualHosts = {
    "${domain}" = {
      forceSSL = true;
      enableACME = true;
      
      locations."/" = {
        proxyPass = "http://${config.services.grafana.addr}:${toString config.services.grafana.port}";
      };
    };
  };
}

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.kanboard;
  
  ncfg = config.services.nginx;

  kanboardConfig = pkgs.writeText "config.php" ''
    <?php
    define('DEBUG', false);
    define('LOG_DRIVER', 'stdout');

    define('PLUGINS_DIR', 'plugins');
    define('PLUGIN_INSTALLER', false);

    define('FILES_DIR', 'data/files');

    ${cfg.config}
  '';

  kanboardRoot = pkgs.kanboard.override {
    appConfig = kanboardConfig;
    stateDir = cfg.stateDir;
    plugins = cfg.plugins;
  };

  unitUser = {
    serviceConfig = {
      User = "${ncfg.user}";
      Group = "${ncfg.group}";
    };
  };

  kanboardPluginUnits = imap
    (i: v: { "kanboard-plugin-${toString i}" =
      (v kanboardRoot) // {
        serviceConfig = {
          User = "${ncfg.user}";
          Group = "${ncfg.group}";
        };
      };
    })
    (catAttrs "unit" cfg.plugins);
in
{
  options = {
    services.kanboard = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };

      plugins = mkOption {
        type = types.listOf types.attrs;
        default = [];
      };

      subdomain = mkOption {
        type = types.str;
        default = "kanboard";
      };

      stateDir = mkOption {
        type = types.path;
        default = "/var/lib/kanboard";
      };

      config = mkOption {
        type = types.lines;
        default = "";
      };  
    };
  };

  config = mkIf cfg.enable {
    services.phpfpm = {    
      pools = {
        kanboard = {
          listen = "/var/run/php-fpm-kanboard.sock";
          extraConfig = ''
            user = ${ncfg.user}
            group = ${ncfg.group}

            catch_workers_output= yes

            listen.owner = ${ncfg.user}
            listen.group = ${ncfg.group}
            listen.mode = 0660

            pm = dynamic
            pm.max_children = 5
            pm.start_servers = 1
            pm.min_spare_servers = 1
            pm.max_spare_servers = 5
          '';
        };
      };
    }; 
  
    services.nginx.virtualHosts = {
      "${cfg.subdomain}.${config.networking.hosttimescaledb
              fastcgi_split_path_info ^(.+\.php)(/.+)$;
              fastcgi_pass unix:/var/run/php-fpm-kanboard.sock;
              fastcgi_index index.php;
          }

          error_page 500 502 503 504 /50x.html;

          # deny access to the directory data
          location ~* /data {
              deny all;
              return 404;
          }

          # deny access to files starting with a dot
          location ~ /\. {
            access_log off;
            log_not_found off;
            return 404;
          }
        '';
      };
    };

    systemd.services = mkMerge ([{
      nginx = {
        preStart = ''
          mkdir -p ${cfg.stateDir}
          chown -R ${ncfg.user}:${ncfg.group} ${cfg.stateDir}
        '';
      };

      kanboard-maintenance = {
        path = [ kanboardRoot pkgs.php ];
        script = ''
          cd ${kanboardRoot}
          ./cli cronjob >/dev/null 2>&1
        '';
        serviceConfig = {
          User = "${ncfg.user}";
          Group = "${ncfg.group}";
        };
      };
    }] ++ kanboardPluginUnits);

    systemd.timers.kanboard-maintenance = {
      description = "Run daily kanboard job";
      partOf = [ "kanboard-maintenance.service" ];
      wantedBy = [ "timers.target" ];
      timerConfig.OnCalendar = "daily";
      timerConfig.Persistent = true;
    };
  };
}

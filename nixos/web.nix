{ config, lib, pkgs, ... }:

with pkgs;
with lib;

let
  domain = "${config.networking.hostName}";
  
  homeDir = "/var/lib/nginx";
  
  cfg = config.services.nginx;
in
{
  config.services.nginx = {
    user = "nginx";
    group = "nginx";
    stateDir = "${homeDir}";

    package = stdenv.lib.overrideDerivation nginx (super : rec {
      postInstall = ''
        ${openssl.bin}/bin/openssl dhparam -out "$out/dhparam.pem" 4096
      '';
    });

    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = false;

    serverTokens = false;
    statusPage = true;

    sslCiphers = "EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH";
    sslDhparam = "${cfg.package}/dhparam.pem";
    sslProtocols = "TLSv1 TLSv1.1 TLSv1.2";
    
    appendHttpConfig = ''
      log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

      ssl_prefer_server_ciphers on;

      ssl_ecdh_curve secp384r1;
      ssl_session_cache shared:SSL:16m;
      ssl_session_tickets off;

      ssl_stapling on;
      ssl_stapling_verify on;

      resolver 8.8.8.8 8.8.4.4 valid=300s;
      resolver_timeout 5s;

      add_header Strict-Transport-Security "max-age=63072000; includeSubdomains" always;
      add_header X-Frame-Options SAMEORIGIN;
      add_header X-Content-Type-Options nosniff;
    '';

    virtualHosts = {
      "${domain}" = {
        serverAliases = [ "www.${domain}" ];
        default = true;

        forceSSL = true;
        enableACME = true;
      };
    };
  };

  config.security.acme.certs = filterAttrs (n: v: v != {}) (
      mapAttrs (vhostName: vhostConfig:
        optionalAttrs vhostConfig.enableACME {
          group = cfg.group;
          allowKeysForGroup = true;
        }
      ) cfg.virtualHosts
  );
}

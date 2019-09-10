{ config, lib, pkgs, ... }:

with pkgs;
with lib;

let
  domain = "${config.networking.hostName}";
  secrets = import ./secrets.nix;
in
{
  imports = [
    ./modules/kanboard.nix
  ];

  config = {
    services.beanstalkd.enable = true;

    services.kanboard = {
      enable = true;
      subdomain = "tasks";
      plugins = [ pkgs.kanboardPlugins.beanstalk pkgs.kanboardPlugins.nebula ];
      config = ''
        define('DB_DRIVER', 'postgres');
        define('DB_HOSTNAME', '127.0.0.1');
        define('DB_PORT', 5432);
        define('DB_NAME', 'kanboard');
        define('DB_USERNAME', 'kanboard');
        define('DB_PASSWORD', 'kanboard');

        define('MAIL_CONFIGURATION', false);
        define('MAIL_TRANSPORT', 'smtp');
        define('MAIL_SMTP_HOSTNAME', '${secrets.smtp.host}');
        define('MAIL_SMTP_PORT', ${secrets.smtp.port});
        define('MAIL_SMTP_USERNAME', '${secrets.smtp.user}');
        define('MAIL_SMTP_PASSWORD', '${secrets.smtp.password}');
        define('MAIL_SMTP_ENCRYPTION', 'tls');
        define('MAIL_FROM', 'tasks@${domain}');
        
        define('BRUTEFORCE_CAPTCHA', 3);
        define('BRUTEFORCE_LOCKDOWN', 10);
        define('BRUTEFORCE_LOCKDOWN_DURATION', 15);
        define('ENABLE_HSTS', true);
        define('ENABLE_XFRAME', true);

        define('REMEMBER_ME_AUTH', false);
        define('SESSION_DURATION', 86400); # 1 day

        define('ENABLE_URL_REWRITE', true);
        define('MARKDOWN_ESCAPE_HTML', true);
      '';
    };

    services.postgresql.init.kanboard = ''
      CREATE ROLE kanboard WITH LOGIN;
      CREATE DATABASE kanboard OWNER kanboard;
    '';
  };
}

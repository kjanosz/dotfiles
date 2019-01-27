{ config, lib, pkgs, ... }:

with lib;

{
  users.users.kjw = {
    extraGroups = [ "docker" "vboxusers" ];
    packages = with pkgs; [
      ansible
      awscli
      aws-vault
      clojure
      unstable.flyway
      go
      leiningen
      mysql57
      nailgun
      nodejs
      unstable.packer
      unstable.slack
      albacross.summon-aws-secrets
      albacross.terraform
    ];
  };
}


{ config, lib, pkgs, ... }:

{
  imports = [
    ./common.nix
    ./hardware-configuration.nix
    ./storage.nix
    # ./monitoring.nix
    ./tasks.nix
    ./web.nix
  ];

  boot.loader.grub.device = "/dev/vda";

  networking = {
    hostName = "kjanosz.com";
    firewall.allowedTCPPorts = [ 80 443 ];
    wireless.enable = false;
  };

  time.timeZone = "Europe/Frankfurt";

  nixpkgs.overlays = [ (import ./overlays) ];

  services.openssh = {
    enable = true;
    permitRootLogin = "no";
    extraConfig = ''
      StreamLocalBindUnlink yes
    '';
  };

  security.pam = {
    enableSSHAgentAuth = true;
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  users.extraUsers.kj = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [  "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQD2ur6Nh/oQUWaqY3PB97r0VjdqJiM+BkOYUFysNbTba8wYzlXjRSzc/4roUFkI7GGW/KYAFCg1HCK319gs1qNs6QrdWTGBCDsvYbzG+XvsKzz4Lk8y786w9VjSDPbyRvlOx6nmtYgh9UqZSUkb1D16da9aCcy87RrSU04LZZeZoPFq4r51A/VwyHzvNRFgbiUVQWhNZ/uEcYPxH55TBtq+/DfKrSSBH76LVUjXOGkGutIAexjbEG9jdHkI15L0EUNwe6cwC4LSKfkK/zDqZ2Fs0aRDW1n6ngholWISUspjyc0SUicSy5RP9V/V8tiarcf+0E1cqbdMp+fT/WglbJJ6+/suBaZGuRKC+rqT4hZSRNQ3jluU/tRk914mdUqUleJWr+wTg8/6L9+y/6Z2kbquMWAfcv00DgIyjULbBlcY3ASWE5BeX+mYVhfl60wv62p+74tP99r3HLJTuiuYuGXq/f0Pxa8NZm0bSIc35eHz2RdNbgyJBDX/Ma1orZ19jQCzQ62s75dAZfyqZRpcdJ60Qa4tkB8xchAU6pQM/Pe/BLTFaTx8W3Ji0eta0PxE0yLmiSZ2hTPf67c1dppV26U9AAo00uG0/xoIboTIWjxKpbHJPtASGUbAF69q8EeZaRrwd2DadJoOIxCCKFRmgeD834XYzJ1uOqc/bwtz8/E2RQ==" ];
  };

  services.nginx = {
    enable = true;
  };

  system.autoUpgrade = {
    enable = true;
    dates = "04:00";
  };

  virtualisation.docker.enable = true;
}

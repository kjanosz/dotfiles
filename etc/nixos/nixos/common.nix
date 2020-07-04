{ config, lib, pkgs, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
  ];

  boot.loader.grub = {
    enable = true;
    version = 2;
  };
    
  console.keyMap = "pl";
  i18n.defaultLocale = "en_DK.UTF-8";

  programs.zsh = {
    enable = true;
    enableCompletion = true;
  };

  services.logind.extraConfig = ''
    KillUserProcesses=yes
  '';

  users = {
    defaultUserShell = pkgs.zsh;
    mutableUsers = false;
  };

  nix = {
    autoOptimiseStore = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 10d";
    };
    useSandbox = "relaxed";
  };
  
  environment.pathsToLink = [ "/share/oh-my-zsh" ];
  environment.systemPackages = with pkgs; [
    calc
    cloc
    coreutils
    duplicity
    file
    findutils
    git
    gptfdisk
    gnupg
    gnupg1compat
    gnutar
    htop
    jq
    lnav
    lsof
    ltrace
    mkpasswd
    oh-my-zsh
    pciutils
    pcsctools
    psmisc
    pwgen
    ranger
    smartmontools
    strace
    unzip
    usbutils
    vim
    zip
  ];
}

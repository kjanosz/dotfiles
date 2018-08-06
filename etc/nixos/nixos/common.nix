{ config, lib, pkgs, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
  ];

  boot.loader.grub = {
    enable = true;
    version = 2;
  };
    
  i18n = {
    consoleKeyMap = "pl";
    defaultLocale = "en_DK.UTF-8";
  };

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
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
    useSandbox = true;
  };

  nixpkgs.config.allowUnfree = false;
  
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
    nix-repl
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

  system.stateVersion = "18.03";
}

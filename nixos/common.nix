{ config, pkgs, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
  ];

  boot.loader.grub = {
    enable = true;
    version = 2;
  };
    
  i18n = {
    consoleFont = "Lat2-Terminus16";
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
    
  environment.systemPackages = with pkgs; [
    coreutils
    git
    htop
    lsof
    ltrace
    mkpasswd
    psmisc
    strace
    vim
  ];
}

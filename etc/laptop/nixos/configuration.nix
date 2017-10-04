{ config, lib, pkgs, pkgs_unstable, ... }:

let
  secrets = import ./secrets.nix;
in
{
  imports = [
    ./common.nix
    ./hardware-configuration.nix
    ./modules/dev.nix
    ./modules/work.nix
    secrets.config
  ];

  networking = {
    hostName = "nixos";
    extraHosts = "127.0.0.1 ${config.networking.hostName}";
    nameservers = [ "130.255.73.90" "104.238.186.189" "185.121.177.177" "185.121.177.53" "50.116.40.226" ]; # OpenNIC DNS servers with DNSCrypt enabled
    networkmanager = {
      enable = true;
      insertNameservers = config.networking.nameservers;
    };
  };

  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    support32Bit = true;
    extraConfig = ''
      load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1
    '';
  };

  fonts = {
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      font-awesome-ttf
      inconsolata
      source-code-pro
      terminus_font
    ];
  };

  i18n = {
    consoleFont = "ter-m24n";
    consolePackages = with pkgs; [ terminus_font ];
    inputMethod = {
      enabled = "fcitx";
      fcitx.engines = with pkgs.fcitx-engines; [ m17n table-other ];
    };
  };
  
  time.timeZone = "Europe/Warsaw";

  nix = {
    buildCores = 8;
    maxJobs = 8;
  };  
  
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.packageOverrides = pkgs: with pkgs; {    
    base16-builder = callPackage ./pkgs/base16-builder { };

    desktop_utils = callPackage ./pkgs/desktop_utils { };

    emacs = callPackage ./pkgs/emacs { };

    calibre = pkgs.calibre.overrideAttrs (oldAttrs: {
      buildInputs = oldAttrs.buildInputs ++ [ python27Packages.dns ];
    });

    inherit (pkgs_unstable) i3;
  };

  environment.systemPackages = with pkgs; [
    acpi
    aspell
    aspellDicts.de
    aspellDicts.en
    aspellDicts.pl
    base16-builder
    bindfs
    calibre
    chromium
    desktop_utils.i3-lock-screen
    desktop_utils.i3-merge-configs
    dropbox
    dunst
    exiv2
    firefox
    feh
    ghostscript
    gimp-with-plugins
    gtk-engine-murrine
    haskellPackages.hledger
    i3lock
    i3status
    imagemagick
    inkscape
    keepassx2
    libnotify
    libreoffice
    lightdm
    mpv
    ncmpcpp
    networkmanagerapplet
    numix-gtk-theme
    numix-icon-theme
    numix-icon-theme-circle
    pass
    pavucontrol
    pdftk
    python27Packages.py3status
    rofi
    termite
    texlive.combined.scheme-full
    thunderbird
    xss-lock
    zathura
  ];
  
  programs.ssh.startAgent = false;
  
  services.pcscd.enable = true;

  services.xserver = {
    enable = true;
    layout = "pl";

    synaptics = {
      enable = true;
      twoFingerScroll = true;
      tapButtons = true;
      fingersMap = [1 3 2];
    };

    desktopManager.xterm.enable = false;
    displayManager.lightdm.enable = true;
    windowManager.i3 = {
      enable = true;
      extraSessionCommands = ''
         # Set GTK_PATH so that GTK+ can find the theme engines.
         export GTK_PATH="${config.system.path}/lib/gtk-2.0:${config.system.path}/lib/gtk-3.0"

         # Set GTK_DATA_PREFIX so that GTK+ can find the Xfce themes.
         export GTK_DATA_PREFIX=${config.system.path}
      
         # SVG loader for pixbuf (needed for GTK svg icon themes)
         export GDK_PIXBUF_MODULE_FILE=`echo ${pkgs.librsvg.out}/lib/gdk-pixbuf-2.0/*/loaders.cache` # */
      '';
    };  
  };

  services.mopidy = {
    enable = true;
    extensionPackages = [ pkgs.mopidy-mopify pkgs.mopidy-spotify pkgs.mopidy-spotify-tunigo ];
    configuration = ''
      [audio]
      output = pulsesink server=127.0.0.1

      [spotify]
      enabled = true
      username = kjanosz
      password = ${secrets.spotify.password}
      client_id = ${secrets.spotify.clientId}
      client_secret = ${secrets.spotify.clientSecret}
      bitrate = 320
    '';
  };

  systemd.services.gnupgshare = {
    wantedBy = [ "user-10000.slice" ];
    partOf = [ "user-10000.slice" ];
    
    path = [ pkgs.bindfs pkgs.utillinux ];
    preStart = "mkdir -p ${config.users.users.kjw.home}/.gnupg";
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
      ExecStart = ''
        ${pkgs.bindfs}/bin/bindfs -u kj -g users -M kjw -p 0600,u+D \
          ${config.users.users.kj.home}/.gnupg ${config.users.users.kjw.home}/.gnupg
      '';
      ExecStop = "${pkgs.utillinux}/bin/umount ${config.users.users.kjw.home}/.gnupg";
    };
  };

  systemd.services.passshare = {
    wantedBy = [ "user-10000.slice" ];
    partOf = [ "user-10000.slice" ];

    path = [ pkgs.bindfs pkgs.utillinux ];
    preStart = "mkdir -p ${config.users.users.kjw.home}/.pass";
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
      ExecStart = ''
        ${pkgs.bindfs}/bin/bindfs -u kj -g users -M kjw -p 0600,u+D \
          ${config.users.users.kj.home}/.pass ${config.users.users.kjw.home}/.pass
      '';
      ExecStop = "${pkgs.utillinux}/bin/umount ${config.users.users.kjw.home}/.pass";
    };
  };

  systemd.user.services.gnupg = {
    after = [ "default.target" ];
    
    path = [ pkgs.gnupg ];
    script = ''
      gpg-agent --homedir $HOME/.gnupg --use-standard-socket --daemon
    '';
    serviceConfig = {
      Type = "forking";
      Restart = "always";
      KillSignal = "SIGKILL";
    };
  };

  users.extraUsers.kj = {
    hashedPassword = "${secrets.kjPassword}";
    uid = 1000;
    isNormalUser = true;
    home = "/home/kj";
    description = "Krzysztof Janosz";
    extraGroups = [ "docker" "networkmanager" "vboxusers" "wheel" ]; 
  };

  users.extraUsers.kjw = {
    hashedPassword = "${secrets.kjwPassword}";
    uid = 10000;
    isNormalUser = true;
    home = "/home/kjw";
    description = "Krzysztof Janosz (Work)";
    extraGroups = [ "docker" "networkmanager" "vboxusers" ];
  };
}

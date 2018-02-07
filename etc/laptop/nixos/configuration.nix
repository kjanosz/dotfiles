{ config, lib, pkgs, ... }:

with (import ./lib.nix { inherit pkgs; });

let
  secrets = import ./secrets.nix;

  pkgs_08_01_2018 = nixpkgsOf {
     rev = "85b84527f636c60bd8c0f0567bb471d491fb5a89";
     sha256 = "04ylvsa8z52wwbsp6bpx3nrr3ycsd5ambsbwgb8xz1zbx64m7zc1";
     config = {
       allowUnfree = true;
     };
  };

  mopidy =  moduleFromGitHubOf {
    path = "services/audio/mopidy.nix";
    rev = "85b84527f636c60bd8c0f0567bb471d491fb5a89";
    sha256 = "fc545fcf00d03f6b4ec13f099cbab970bc4a986b8140c78397c413dd7e5e9828";
  };
in
{
  imports = [
    ./common.nix
    ./hardware-configuration.nix
    ./modules/dev.nix
    ./modules/gpg-profiles.nix
    ./modules/work.nix
    secrets
    mopidy
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

  nixpkgs.config = {
    allowUnfree = true;

    packageOverrides = pkgs: with pkgs; {    
      base16-builder = callPackage ./pkgs/base16-builder { };

      calibre = pkgs.calibre.overrideAttrs (oldAttrs: {
        buildInputs = oldAttrs.buildInputs ++ [ python27Packages.dns ];
      });

      desktop_utils = callPackage ./pkgs/desktop_utils { };

      emacs = callPackage ./pkgs/emacs { };

      mopidy = pkgs_08_01_2018.mopidy;
    };
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
    desktop_utils.i3-lock-screen
    desktop_utils.i3-merge-configs
    dropbox
    dunst
    exiv2
    feh
    ghostscript
    gimp-with-plugins
    gtk-engine-murrine
    i3lock
    i3status
    imagemagick
    imgurbash2
    inkscape
    keepassx2
    keybase
    keybase-gui
    libnotify
    libreoffice
    lightdm
    lm_sensors
    mpv
    ncmpcpp
    networkmanagerapplet
    numix-gtk-theme
    numix-icon-theme
    numix-icon-theme-circle
    pass
    pavucontrol
    pdftk
    rofi
    termite
    texlive.combined.scheme-full
    upower
    xss-lock
    zathura
  ];

  programs.browserpass.enable = true;
  
  programs.ssh.startAgent = false;
  
  services.pcscd.enable = true;

  services.upower.enable = true;

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
    dataDir = "/var/lib/mopidy";
    extensionPackages = with pkgs_08_01_2018; [ mopidy-mopify mopidy-spotify mopidy-youtube ];
    configuration = ''
      [audio]
      output = pulsesink server=127.0.0.1
    '';
    extraConfigFiles = [ "${config.services.mopidy.dataDir}/spotify.conf" ];
  };

  services.gnupg.profiles = {
    default = {
      gpg-agent = ''
        default-cache-ttl 10
        max-cache-ttl 10

        enable-ssh-support
        default-cache-ttl-ssh 10
        max-cache-ttl-ssh 10
      '';

      scdaemon = ''
        deny-admin
        reader-port "Yubico Yubikey 4 OTP+U2F+CCID"
        card-timeout 60
      '';
    };

    additional = {
      internal-reader = {
        scdaemon = ''
          reader-port "Broadcom Corp 5880 [Contacted SmartCard] (0123456789ABCD)"
          card-timeout 1
        '';
      };

      mobile-reader = {
        scdaemon = ''
          reader-port "Gemalto USB Shell Token V2 (FF4C23A4)"
          card-timeout 1
        '';
      };

      pinpad-reader = {
        scdaemon = ''
          reader-port "Cherry GmbH SmartTerminal ST-2xxx [Vendor Interface] (21121451108871)"
          card-timeout 1
        '';
      };
    };
  };

  services.keybase.enable = true;
  services.kbfs = {
    enable = true;
    mountPoint = "%h/Shared/Keybase";
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

  users.extraUsers.kj = {
    passwordFile = "/var/lib/users/kj.password";
    uid = 1000;
    isNormalUser = true;
    home = "/home/kj";
    description = "Krzysztof Janosz";
    extraGroups = [ "docker" "networkmanager" "vboxusers" "wheel" ];
    packages = with pkgs; [ hledger hledger-web chromium firefox thunderbird wine winetricks ];
  };

  users.extraUsers.kjw = {
    passwordFile = "/var/lib/users/kjw.password";
    uid = 10000;
    isNormalUser = true;
    home = "/home/kjw";
    description = "Krzysztof Janosz (Work)";
    extraGroups = [ "docker" "networkmanager" "vboxusers" ];
    packages = with pkgs; [ chromium ];
  };

  # Ledger Nano S
  services.udev.extraRules = ''
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="1b7c", MODE="0660", GROUP="users"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="2b7c", MODE="0660", GROUP="users"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="3b7c", MODE="0660", GROUP="users"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="4b7c", MODE="0660", GROUP="users"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="1807", MODE="0660", GROUP="users"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="1808", MODE="0660", GROUP="users"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="0000", MODE="0660", GROUP="users"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="0001", MODE="0660", GROUP="users"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="1b7c", MODE="0660", TAG+="uaccess", TAG+="udev-acl"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="2b7c", MODE="0660", TAG+="uaccess", TAG+="udev-acl"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="3b7c", MODE="0660", TAG+="uaccess", TAG+="udev-acl"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="4b7c", MODE="0660", TAG+="uaccess", TAG+="udev-acl"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="1807", MODE="0660", TAG+="uaccess", TAG+="udev-acl"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="1808", MODE="0660", TAG+="uaccess", TAG+="udev-acl"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="0000", MODE="0660", TAG+="uaccess", TAG+="udev-acl"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="0001", MODE="0660", TAG+="uaccess", TAG+="udev-acl"
  '';
  
  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableHardening = true;
}

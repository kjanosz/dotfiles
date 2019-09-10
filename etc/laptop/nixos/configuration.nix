{ config, lib, pkgs, ... }:

{
  imports = [
    ./cachix.nix
    ./common.nix
    ./secrets.nix
    # ./modules/backup.nix
    ./modules/gpg-profiles.nix
    ./dev.nix
    ./work.nix
  ];

  networking = {
    hostName = "nixos";
    extraHosts = "127.0.0.1 ${config.networking.hostName}";
    networkmanager.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    extraConfig = ''
      [General]
      Enable=Source,Sink,Media,Socket
    '';
  };  

  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    support32Bit = true;
    extraConfig = ''
      load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1
    '';
  };
  sound.mediaKeys = {
    enable = true;
    volumeStep = "5%";
  };

  hardware.opengl = {
    driSupport32Bit = true;
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
    extraOptions = ''
      keep-derivations = true
      keep-outputs = true
    '';
  };  
  
  nixpkgs = {
    config = {
      allowUnfree = true;
      chromium = {
        enableWideVine = true;
      };
    };
    overlays = [ (import ./overlays) ];
  };  

  environment.extraInit = let
    cp = "cp --no-preserve=mode --remove-destination --symbolic-link --recursive";
  in ''
    if [ "$USER" != "root" ]; then
      GLOBAL="/run/current-system/sw/lib/mozilla/native-messaging-hosts"
      PER_USER="etc/per-user-pkgs/$USER/lib/mozilla/native-messaging-hosts"

      rm -rf $HOME/.mozilla/native-messaging-hosts
      mkdir -p $HOME/.mozilla/native-messaging-hosts
      [ -d "$GLOBAL" ] && ${cp} "$GLOBAL"  "$HOME/.mozilla/"
      [ -d "$PER_USER" ] && ${cp} "$PER_USER" "$HOME/.mozilla/"
    fi  
  '';

  environment.systemPackages = with pkgs; [
    acpi
    appimage-run
    asciidoc-full-with-plugins
    asciidoctor
    aspell
    aspellDicts.de
    aspellDicts.en
    aspellDicts.pl
    bindfs
    blueman
    unstable.browserpass
    cachix
    calibre
    unstable.chromium
    desktop_utils.i3-lock-screen
    desktop_utils.i3-merge-configs
    dmidecode
    dunst
    exiv2
    feh
    unstable.firefox-unwrapped
    ghostscript
    gimp-with-plugins
    go-mtpfs
    google-chrome
    unstable.gopass
    gtk-engine-murrine
    hdparm
    i3lock
    i3status
    imagemagick
    imgurbash2
    inkscape
    unstable.keybase
    unstable.keybase-gui
    libnotify
    libreoffice
    lightdm
    lm_sensors
    mpv
    unstable.mullvad-vpn
    ncmpcpp
    networkmanagerapplet
    nix-prefetch-github
    nix-prefetch-scripts
    numix-gtk-theme
    numix-icon-theme
    numix-icon-theme-circle
    pass # for protonmail-bridge
    pavucontrol
    pdftk
    unstable.protonmail-bridge
    rofi
    rofi-pass
    samba
    termite
    texlive.combined.scheme-full
    tomb
    unrar
    upower
    xdotool
    xsel
    xss-lock
    xzoom
    zathura
  ];

  security.sudo.extraRules = [
    {
      groups = [ "wheel" ];
      commands = [
        {
          command = "/run/current-system/sw/bin/nixos-rebuild";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/nix-collect-garbage";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
  
  programs.ssh.startAgent = false;

  programs.browserpass.enable = true;
  
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
    extensionPackages = with pkgs; [ mopidy-mopify mopidy-spotify ];
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
        reader-port "Yubico YubiKey OTP+FIDO+CCID"
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

  users.users.kj = {
    passwordFile = "/var/lib/users/kj.password";
    uid = 1000;
    isNormalUser = true;
    home = "/home/kj";
    description = "Krzysztof Janosz";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ cabextract hledger playonlinux steam thunderbird wine ];
  };

  users.users.kjw = {
    passwordFile = "/var/lib/users/kjw.password";
    uid = 10000;
    isNormalUser = true;
    home = "/home/kjw";
    description = "Krzysztof Janosz (Work)";
    extraGroups = [ "networkmanager" ];
    packages = with pkgs; [ ];
  };
}

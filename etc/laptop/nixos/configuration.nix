{ config, lib, pkgs, ... }:

let
  mullvadDNS = "193.138.218.74";
in
{
  imports = [
    ./cachix.nix
    ./common.nix
    ./secrets.nix
    # ./modules/backup.nix
    ./modules/gpg-profiles.nix
    ./modules/mullvad.nix
    ./dev.nix
  ];

  networking = {
    hostName = "nixos";
    extraHosts = "127.0.0.1 ${config.networking.hostName}";
    nameservers = [ "193.138.218.74" ];
    networkmanager.enable = true;
    wireguard.enable = true;
  };
  services.mullvad.enable = true;

  hardware.bluetooth = {
    enable = true;
    config = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };  

  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    support32Bit = true;
    tcp = {
      enable = true;
      anonymousClients.allowedIpRanges = [ "127.0.0.1" ];
    };
  };

  hardware.opengl = {
    driSupport32Bit = true;
  };

  location.provider = "geoclue2";
  services.geoclue2.enable = true;
  time.timeZone = "Europe/Warsaw";

  hardware.acpilight.enable = true;
  services.redshift = {
    enable = true;
    temperature = {
      day = 6500;
      night = 4000;
    };
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

  console = {
    font = "ter-m24n";
    packages = with pkgs; [ terminus_font ];
  };
  i18n.inputMethod = {
    enabled = "fcitx";
    fcitx.engines = with pkgs.fcitx-engines; [ m17n table-other ];
  };
  
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

  programs.browserpass.enable = true;
  
  services.upower.enable = true;

  services.udev.packages = with pkgs; [ 
    libu2f-host
    yubikey-personalization 
  ];

  programs.gnupg = {
    agent = {
      enable = true;
      enableBrowserSocket = true;
      enableExtraSocket = true;
      enableSSHSupport = true;
      pinentryFlavor = "gtk2";
    };
  };
  programs.ssh.startAgent = false;
  services.pcscd.enable = true;
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
  systemd.services.gnupgshare = {
    partOf = [ "user@10000.service" ];
    wantedBy = [ "user@10000.service" ];
    
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

  services.keybase.enable = true;
  services.kbfs = {
    enable = true;
    mountPoint = "%h/Shared/Keybase";
  };

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
  services.gnome3.glib-networking.enable = true;

  environment.extraInit = let
    cp = "cp --no-preserve=mode --remove-destination --symbolic-link --recursive";
  in ''
    if [ "$USER" != "root" ]; then
      GLOBAL="/run/current-system/sw/lib/mozilla/native-messaging-hosts"
      PER_USER="etc/per-user-pkgs/$USER/lib/mozilla/native-messaging-hosts"

      rm -rf $HOME/.mozilla/native-messaging-hosts
      [ -d "$GLOBAL" ] && ${cp} "$GLOBAL"  "$HOME/.mozilla/"
      [ -d "$PER_USER" ] && ${cp} "$PER_USER" "$HOME/.mozilla/"
    fi  
  '';

  environment.systemPackages = with pkgs; [
    acpi
    acpilight
    appimage-run
    asciidoc-full-with-plugins
    asciidoctor
    aspell
    aspellDicts.de
    aspellDicts.en
    aspellDicts.pl
    bindfs
    blueman
    browserpass
    cachix
    calibre
    chromium
    desktop_utils.i3-lock-screen
    desktop_utils.i3-merge-configs
    dmidecode
    dunst
    exiv2
    feh
    firefox
    gimp-with-plugins
    go-mtpfs
    gopass
    gtk-engine-murrine
    hdparm
    i3lock
    i3status
    imagemagick
    imgurbash2
    inkscape
    keybase-gui
    libnotify
    libreoffice
    lightdm
    lm_sensors
    mellowplayer
    mpv
    mullvad-vpn
    ncmpcpp
    networkmanagerapplet
    nix-prefetch-github
    nix-prefetch-scripts
    numix-gtk-theme
    numix-icon-theme
    numix-icon-theme-circle
    pandoc
    pavucontrol
    pdftk
    playerctl
    unstable.protonmail-bridge
    redshift
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
    yubico-piv-tool
    yubikey-manager
    yubikey-manager-qt
    yubikey-personalization
    zathura
  ];

  users.users.kj = {
    passwordFile = "/var/lib/users/kj.password";
    uid = 1000;
    isNormalUser = true;
    home = "/home/kj";
    description = "Krzysztof Janosz";
    extraGroups = [ "networkmanager" "wheel" "video" ];
    packages = with pkgs; [ 
      cabextract 
      hledger 
      lutris
      playonlinux 
      (steam.override { extraPkgs = pkgs: [ libffi qt5.qtbase qt5.qttools qt5.qtsvg ]; })
      thunderbird 
      wine 
    ];
  };

  users.users.kjw = {
    passwordFile = "/var/lib/users/kjw.password";
    uid = 10000;
    isNormalUser = true;
    home = "/home/kjw";
    description = "Krzysztof Janosz (Work)";
    extraGroups = [ "networkmanager" "video" ];
    packages = with pkgs; [ ];
  };
}

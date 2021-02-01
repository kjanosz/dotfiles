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
    ./dev.nix
  ];

  networking = {
    hostName = "nixos";
    extraHosts = "127.0.0.1 ${config.networking.hostName}";
    nameservers = [ mullvadDNS ];
    networkmanager.enable = true;
    wireguard.enable = true;
  };
  services.mullvad-vpn.enable = true;

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
    enable = true;
    driSupport32Bit = true;
  };

  hardware.openrazer = {
    enable = true;
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
    {
      users = [ "kjw" ];
      commands = [
        {
          command = "/run/current-system/sw/bin/systemctl start openvpn-adcolony.service";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/systemctl stop openvpn-adcolony.service";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/systemctl restart openvpn-adcolony.service";
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
  systemd.services.gnupgshare = {
    partOf = [ "user@10000.service" ];
    wantedBy = [ "user@10000.service" ];
    
    path = with pkgs; [ bindfs utillinux ];
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

  boot.plymouth.enable = true;
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
    displayManager.sddm = {
      enable = true;
      enableHidpi = true;
    };
    windowManager.i3 = {
      enable = true;
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

  systemd.services.fava = {
    partOf = [ "user@1000.service" ];
    wantedBy = [ "user@1000.service" ];
    
    path = with pkgs; [ beancount fava ];
    preStart = "mkdir -p ${config.users.users.kjw.home}/.gnupg";
    serviceConfig = {
      Type = "simple";
      ExecStart = ''
        ${pkgs.fava}/bin/fava ${config.users.users.kj.home}/Documents/Finances/2021/main.bean
      '';
    };
  };

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
    beancount
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
    fava
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
    unstable.mellowplayer
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
    razergenie
    redshift
    rofi
    rofi-pass
    samba
    syncthing
    termite
    texlive.combined.scheme-full
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

  virtualisation.oci-containers.backend = "docker";

  users.users.kj = {
    passwordFile = "/var/lib/secrets/kj.pw";
    uid = 1000;
    isNormalUser = true;
    home = "/home/kj";
    description = "Personal";
    extraGroups = [ "networkmanager" "plugdev" "wheel" "video" ];
    packages = with pkgs; [ 
      beancount
      cabextract 
      discord
      fava
      hledger 
      lutris
      unstable.steam
      thunderbird 
      wine 
    ];
  };

  users.users.kjw = {
    passwordFile = "/var/lib/secrets/kjw.pw";
    uid = 10000;
    isNormalUser = true;
    home = "/home/kjw";
    description = "Work";
    extraGroups = [ "networkmanager" "plugdev" "video" ];
    packages = with pkgs; [ ];
  };
}

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./modules/nix-ld/default.nix
      inputs.home-manager.nixosModules.default
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.extraModulePackages = with config.boot.kernelPackages; [v4l2loopback];
  boot.kernelModules = ["v4l2loopback"];
 
  networking.hostName = "void"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable networking
  networking.networkmanager.enable = true;
  networking.nameservers = [ "192.168.1.145" "1.1.1.1" ];
  services.rpcbind.enable = true;
  systemd.mounts = [{
    type = "nfs";
    mountConfig = {
      Options = "noatime";
    };
    what = "192.168.1.144:/mnt/Almacen";
    where = "/mnt/Almacen";
  }];

  systemd.automounts = [{
    wantedBy = [ "multi-user.target" ];
    automountConfig = {
      TimeoutIdleSec = "90";
    };
    where = "/mnt/Almacen";
  }];

  # Set your time zone.
  time.timeZone = "Europe/Madrid";

  # Select internationalisation properties.
  i18n.defaultLocale = "es_ES.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_ES.UTF-8";
    LC_IDENTIFICATION = "es_ES.UTF-8";
    LC_MEASUREMENT = "es_ES.UTF-8";
    LC_MONETARY = "es_ES.UTF-8";
    LC_NAME = "es_ES.UTF-8";
    LC_NUMERIC = "es_ES.UTF-8";
    LC_PAPER = "es_ES.UTF-8";
    LC_TELEPHONE = "es_ES.UTF-8";
    LC_TIME = "es_ES.UTF-8";
  };

  # Configure console keymap
  console.keyMap = "es";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.noi = {
    isNormalUser = true;
    description = "noi";
    extraGroups = [ "networkmanager" "wheel" "dialout" "scanner" "lp" ];
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "noi" = import ./home.nix;
    };
  };
  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.hplipWithPlugin ];
  };
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  services = {
    gvfs.enable = true;
    tumbler.enable = true;
    picom.enable = true;
    openssh.enable = true;
    printing = {
      enable = true;
      drivers = with pkgs; [ hplip ];
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };

    xserver = {
      enable = true;
      xkb.layout = "es";
      xkb.variant = "";
      displayManager.sddm = {
        enable = true;
        wayland.enable = true;
        theme = "where_is_my_sddm_theme";
      };
    }; 
    syncthing = {
      enable = true;
      user = "noi";
      #dataDir = "/home/noi/Default Folder";    # Default folder for new synced folders
      configDir = "/home/noi/.config/syncthing"; 
      settings = {
        devices = {
	  "Pi" = { id = "SIBON2Z-FYVVPAG-TQUG2JU-43BEVSV-ALKQL6W-5UKYAJ5-WO2PSCG-NVI22AM"; };
	  "Phone" = { id = "6ZGQXN3-TC3EX7K-QLNF4GH-WOSQG7Z-DJF63QR-LOCCD5P-BS525FX-AO55RAB"; };
	};
	folders = {
	  "Obsidian Vault" = {
	    path = "/home/noi/Obsidian Vault";
	    devices = [ "Pi" "Phone" ];
	  };
	  "scripts" = {
	    path = "/home/noi/scripts";
	    devices = [ "Pi" "Phone" ];
	  };
	};
      };
    };
  };

  sound.enable = true;
  security.rtkit.enable = true;

  programs = {
    #thunar = {
    #  enable = true;
    #  plugins = with pkgs.xfce; [
    #    thunar-archive-plugin
	  #    thunar-volman
    #  ];
    #};

    hyprland = {
      enable = true;
      xwayland = {
        enable = true;
      };
      portalPackage = pkgs.xdg-desktop-portal-hyprland;
      package = inputs.hyprland.packages."${pkgs.system}".hyprland; 
    };
    
    zsh.enable = true;
    
    adb.enable = true; # enable android proper data tethering
    system-config-printer.enable = true;
  };

  users.defaultUserShell = pkgs.zsh; 

  environment.systemPackages = with pkgs; [
    nfs-utils
    (where-is-my-sddm-theme.override {
      themeConfig.General = {
        background = toString ./login-background.png;
	backgroundMode = "fill";
      };
    })
    (python3.withPackages (pkgs: with pkgs; [
	    pyserial
	    esptool
	    deemix
    ]))
    v4l-utils
    esptool
    firefox
    (wrapFirefox (pkgs.firefox-unwrapped.override { pipewireSupport = true;}) {})
  ];

  xdg.portal = {
    enable = true;
    wlr.enable = false;
    xdgOpenUsePortal = false;
    extraPortals = with pkgs; [
      #xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
    config.common.default = "*";
  };

  environment.sessionVariables = {
    XDG_SESSION_TYPE = "wayland";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    QT_QPA_PLATFORM = "wayland;xcb";
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
 
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}

{ config, inputs, pkgs, hostname, username, deviceName, devices, ... }:
{
  imports =
    [
      ../modules/nix-ld/default.nix
      inputs.home-manager.nixosModules.default
    ];

  networking.hostName = hostname;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.networkmanager.enable = true;
  networking.nameservers = [ "45.148.31.10" "9.9.9.9" ];
  services.rpcbind.enable = true;

  nixpkgs.overlays = [
    inputs.nur.overlays.default
  ];

#  systemd.mounts = [{
#    type = "nfs";
#    mountConfig = {
#      Options = "noatime";
#    };
#    what = "192.168.1.144:/mnt/Almacen";
#    where = "/mnt/Almacen";
#  }];

#  systemd.automounts = [{
#    wantedBy = [ "multi-user.target" ];
#    automountConfig = {
#      TimeoutIdleSec = "60";
#    };
#    where = "/mnt/Almacen";
#  }];

  services.mullvad-vpn.enable = true;

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

  nix.optimise = {
    automatic = true;
    dates = [ "23:30" ]; # Optional; allows customizing optimisation schedule
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
  };
  
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = (pkg: true);

  systemd = {
    services.syncthing-init.after = [ "graphical.target" ];
    targets.network-online.wantedBy = pkgs.lib.mkForce []; # Normally ["multi-user.target"]
    services.NetworkManager-wait-online.wantedBy = pkgs.lib.mkForce []; # Normally ["network-online.target"]
  };
  
  services = {
    gvfs.enable = true;
    tumbler.enable = true;
    #picom.enable = true;
    openssh.enable = true;
    
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
    };
    
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
          user = username;
        };
      };
    };

    syncthing = {
      enable = true;
      user = username;
      configDir = "/home/${username}/.config/syncthing"; 
      settings = {
        devices = devices;
	      folders = {
	        "org" = {
	          path = "/home/${username}/org";
	          devices = [ "Phone" deviceName "Server" ];
	        };
	        "scripts" = {
	          path = "/home/${username}/scripts";
	          devices = [ deviceName "Server" ];
	        };
          "snippets" = {
	          path = "/home/${username}/snippets";
	          devices = [ deviceName "Server" ];
          };
          "code" = {
	          path = "/home/${username}/Code";
	          devices = [ deviceName "Server" ];
          };
          "arduino" = {
	          path = "/home/${username}/Arduino";
	          devices = [ deviceName "Server" ];
          };
	      };
      };
    };
  };

  security.rtkit.enable = true;
  security.polkit.enable = true;

  programs = { 
    zsh.enable = true;
    adb.enable = true; # enable android proper data tethering
  };
  programs.dconf.enable = true;
  users.defaultUserShell = pkgs.zsh;

  environment.systemPackages = with pkgs; [
    nfs-utils
    (python3.withPackages (pkgs: with pkgs; [
	    pyserial
	    esptool
	    deemix
    ]))
    esptool
    arduino-cli #Version 1.0.0 doesn't compile with arduino-cli-mode
    mullvad-vpn
  ];

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    #xdgOpenUsePortal = false;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
    config.common.default = "*";
  };

  environment.sessionVariables = {
    XDG_SESSION_TYPE = "wayland";
    #SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
    XDG_CURRENT_DESKTOP = "sway";
    XDG_SESSION_DESKTOP = "sway";
    QT_QPA_PLATFORM = "wayland;xcb";
  };
  
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}

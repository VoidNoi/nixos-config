{ config, inputs, pkgs, hostname, username, ... }:

{
  imports =
    [
      ../modules/nix-ld/default.nix
      inputs.home-manager.nixosModules.default
    ];

  networking.hostName = hostname;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

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
      TimeoutIdleSec = "60";
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
  
  nixpkgs.config.allowUnfree = true;
  services = {
    gvfs.enable = true;
    tumbler.enable = true;
    picom.enable = true;
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
      #displayManager.sddm = {
      #  enable = true;
      #  wayland.enable = true;
      #  theme = "where_is_my_sddm_theme";
      #};
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
  };
  
  sound.enable = true;
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
    #(where-is-my-sddm-theme.override {
    #  themeConfig.General = {
    #    background = toString ../login-background.png;
	  #    backgroundMode = "fill";
    #  };
    #})
    (python3.withPackages (pkgs: with pkgs; [
	    pyserial
	    esptool
	    deemix
    ]))
    esptool
    #firefox
    #(wrapFirefox (pkgs.firefox-unwrapped.override { pipewireSupport = true;}) {})
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
  
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}

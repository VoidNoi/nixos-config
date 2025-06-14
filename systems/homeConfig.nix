{config, pkgs, inputs, username, ... }: let

  inherit (config.lib.file) mkOutOfStoreSymlink;

in {

  imports = [ 
    ../modules/theme
#    ../modules/picom
    ../modules/zsh
    ../modules/kitty
    ../modules/dunst
    ../modules/rofi
    ../modules/waybar
    ../modules/emacs
    ../modules/sway    
    # ../modules/spicetify
  ];
  
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = username;
  home.homeDirectory = "/home/${username}";

  xdg.desktopEntries = {
    #arduino-ide = {
      #name = "Arduino IDE";
      #exec = "arduino-ide %U";
      #icon = "arduino-ide";
      #terminal = false;
      #type = "Application";
      #comment = "Arduino IDE";
    #};
    cmus = {
      name = "Cmus";
      exec = "cmus";
      terminal = true;
      type = "Application";
      comment = "Cmus";
    };
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.

  programs.git = {
    enable = true;
    userName = "VoidNoi";
    userEmail = "voidnoi@proton.me";
    extraConfig = {
      init.defaultBranch = "main";
      #safe.directory = "/etc/nixos";
    };
  };

  services.wlsunset = {
    enable = true;
    systemdTarget = "graphical-session.target";
    #temperature = {
    #  day = 5000;
    #  night = 4000;
    #};
    sunrise = "07:00";
    sunset = "21:00";
  };
  
  home.packages = with pkgs; [
    neovim
    arduino-ide
    feh
    winetricks
    pulseaudio
    pavucontrol
    unzip
    p7zip
    mpv
    gnome-disk-utility
    file-roller
    nautilus
    unrar
    killall
    lua
    imagemagick
    nix-prefetch-git
    yt-dlp
    gh
    nodejs_22
    inetutils
    exiftool
    librewolf-bin
    brave
    nitch
    clang_18
    ffmpeg
    platformio
    php
    emmet-ls
    nur.repos.nltch.spotify-adblock
    streamrip
  ];

  home.sessionVariables = {
    EDITOR = "emacsclient -c -a 'emacs'";
    BROWSER = "brave";
    TERMINAL = "kitty";
    NIXCONFIG = "~/nixConfig";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

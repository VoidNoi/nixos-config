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
    ../modules/yazi
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
    rmpc = {
      name = "rmpc";
      exec = "rmpc";
      terminal = true;
      type = "Application";
      comment = "rmpc";
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

  programs.rmpc = {
    enable = true;
    config = ''
#![enable(implicit_some)]
#![enable(unwrap_newtypes)]
#![enable(unwrap_variant_newtypes)]
(
    address: "127.0.0.1:6600",
    password: None,
	  enable_config_hot_reload: true,
    cache_dir: None,
    on_song_change: None,
    volume_step: 5,
    max_fps: 30,
    scrolloff: 0,
    wrap_navigation: false,
    enable_mouse: true,
    status_update_interval_ms: 1000,
    select_current_song_on_change: false,
    album_art: (
        method: Auto,
        max_size_px: (width: 500, height: 500),
        disabled_protocols: ["http://", "https://"],
        vertical_align: Center,
        horizontal_align: Center,
    ),
    keybinds: (
        global: {
            ":":       CommandMode,
            ",":       VolumeDown,
            "s":       Stop,
            ".":       VolumeUp,
            "<Tab>":   NextTab,
            "<S-Tab>": PreviousTab,
            "1":       SwitchToTab("Playing"),
            "4":       SwitchToTab("Dir"),
            "3":       SwitchToTab("Lists"),
            "2":       SwitchToTab("Find"),
            "q":       Quit,
            ">":       NextTrack,
            "p":       TogglePause,
            "<":       PreviousTrack,
            "f":       SeekForward,
            "z":       ToggleRepeat,
            "x":       ToggleRandom,
            "c":       ToggleConsume,
            "v":       ToggleSingle,
            "b":       SeekBack,
            "~":       ShowHelp,
            "I":       ShowCurrentSongInfo,
            "O":       ShowOutputs,
            "P":       ShowDecoders,
        },
        navigation: {
            "k":         Up,
            "j":         Down,
            "h":         Left,
            "l":         Right,
            "<Up>":      Up,
            "<Down>":    Down,
            "<Left>":    Left,
            "<Right>":   Right,
            "<C-k>":     PaneUp,
            "<C-j>":     PaneDown,
            "<C-h>":     PaneLeft,
            "<C-l>":     PaneRight,
            "<C-u>":     UpHalf,
            "N":         PreviousResult,
            "a":         Add,
            "A":         AddAll,
            "r":         Rename,
            "n":         NextResult,
            "g":         Top,
            "<Space>":   Select,
            "<C-Space>": InvertSelection,
            "G":         Bottom,
            "<CR>":      Confirm,
            "i":         FocusInput,
            "J":         MoveDown,
            "<C-d>":     DownHalf,
            "/":         EnterSearch,
            "<C-c>":     Close,
            "<Esc>":     Close,
            "K":         MoveUp,
            "D":         Delete,
        },
        queue: {
            "D":       DeleteAll,
            "<CR>":    Play,
            "<C-s>":   Save,
            "a":       AddToPlaylist,
            "d":       Delete,
            "i":       ShowInfo,
            "C":       JumpToCurrent,
        },
    ),
    search: (
        case_sensitive: false,
        mode: Contains,
        tags: [
            (value: "any",         label: "Any Tag"),
            (value: "title",       label: "Title"),
            (value: "album",       label: "Album"),
            (value: "artist",      label: "Artist"),
            (value: "filename",    label: "Filename"),
            (value: "genre",       label: "Genre"),
        ],
    ),
    artists: (
        album_display_mode: SplitByDate,
        album_sort_by: Date,
    ),
    tabs: [
        (
            name: "Playing",
            pane: Split(
                direction: Horizontal,
                panes: [(size: "65%", pane: Pane(Queue)), (size: "35%", pane: Pane(AlbumArt))],
            ),
        ),
        (
            name: "Find",
            pane: Pane(Search),
        ),
       (
            name: "Lists",
            pane: Pane(Playlists),
        ),
       (
            name: "Dir",
            pane: Pane(Directories),
        ),
    ],
)
    '';
  };
  services.mpd = {
    enable = true;
    musicDirectory = "~/Music";
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "My PipeWire Output"
      }    
    '';
    network.startWhenNeeded = true; # systemd feature: only start MPD service upon connection to its socket
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
    nodePackages.browser-sync
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
    fzf
    trash-cli
    ripdrag
    davinci-resolve-studio-paid
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

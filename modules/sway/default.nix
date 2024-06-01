{ pkgs, NIXCONFIG, username, config, lib, monitors, ... }: let
  swayPath = "${NIXCONFIG}/modules/sway";
in {

  home.packages = with pkgs; [
    libnotify
    grim
    slurp
    wl-clipboard
    wlr-randr
  ];

  wayland.windowManager.sway = {
    enable = true;
    checkConfig = false;
    config = rec {
      modifier = "Mod4";
      
      terminal = "kitty";

      input = {
        "type:keyboard" = {
          xkb_layout = "es";
        };
      };
      
      output = monitors;
        
      window = {
        titlebar = false;
      };
      
      startup = [
        {command = "dunst &";}
        {command = "logseq";}
      ];

      gaps = {
        inner = 3;
        outer = 5;
      };
      
      bars = [
        {
          command = "waybar";
          position = "top";
        }
      ];
      
      fonts = {
        names = [ "pango" ];
        style = "monospace";
        size = 0.001;
      };

      colors.focused = {
        background = "#ffffff";
        border = "#c3b1e1";
        text = "#ffffff";
        indicator = "#c3b1e1";
        childBorder = "#c3b1e1";
      };
      
      floating.modifier = "Mod4";
      
      keybindings = let
        modifier = config.wayland.windowManager.sway.config.modifier;
      in lib.mkOptionDefault {
        "${modifier}+w" = "exec floorp";
        "${modifier}+n" = "exec thunar";
        "${modifier}+d" = "exec rofi -show drun -show-icons";
        "${modifier}+Return" = "exec kitty";
        "${modifier}+Shift+p" = "exec grim -l 0 -g \"$(slurp)\"";
        "${modifier}+c" = "kill";
        "${modifier}+Shift+c" = "reload";
        "${modifier}+Shift+r" = "restart";
        
        "${modifier}+space" = "focus mode_toggle";
        "${modifier}+Shift+space" = "floating toggle";
        
        "${modifier}+s" = "layout stacking";
        "${modifier}+g" = "layout tabbed";
        "${modifier}+e" = "layout toggle split";

        "${modifier}+f" = "fullscreen toggle";

        "${modifier}+v" = "splitv";
        "${modifier}+h" = "splith";

        "${modifier}+Shift+Left" = "move left";
        "${modifier}+Shift+Down" = "move down";
        "${modifier}+Shift+Up" = "move up";
        "${modifier}+Shift+Right" = "move right";

        "${modifier}+Ctrl+comma" = "move workspace to output right";
        "${modifier}+Ctrl+period" = "move workspace to output left";

        "${modifier}+Left" = "focus left";
        "${modifier}+Down" = "focus down";
        "${modifier}+Up" = "focus up";
        "${modifier}+Right" = "focus right";
        "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
        "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
        "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
        "XF86MonBrightnessUp" = "exec brightnessctl set 5%+";
        "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
        
      }; 
    };
    extraConfig = ''
      seat * xcursor_theme Catppuccin-Macchiato-Dark-Cursors 20
      exec_always xrandr --output HDMI-A-2 --primary
    '';
  };
}

{ pkgs, NIXCONFIG, config, lib, monitors, ... }: let
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
      defaultWorkspace = "workspace number 1";
      modifier = "Mod4";
      
      terminal = "kitty";

      input = {
        "type:keyboard" = {
          xkb_layout = "es";
        };
        "type:touchpad" = {
          dwt = "enabled";
          tap = "enabled";
          middle_emulation = "enabled";
        };
      };
      floating.criteria = [
        {
          title = "Confirmar para reemplazar archivos";
        }
        {
          title = "Progreso de las operaciones de archivo";
        }
        {
          title = "Picture-in-Picture";
        }
        {
          title = "Control de volumen";
          class = "pavucontrol";
        }
        {
          title = "Friends List";
          class = "steam";
        }
        {
          title = "Steam Settings";
          class = "steam";
        }
        {
          title = "Add Non-Steam Game";
          class = "steam";
        }
        {
          title = "Pick game to add";
          class = "steam";
        }
      ];
      
      output = monitors;
        
      window = {
        titlebar = false;
      };
      
      startup = [
        {command = "dunst &";}
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
        "${modifier}+w" = "exec brave";
        "${modifier}+n" = "exec nautilus";
        "${modifier}+d" = "exec rofi -show drun -show-icons";
        "${modifier}+Return" = "exec kitty";
        "${modifier}+Shift+p" = "exec grim -l 0 -g \"$(slurp)\"";
        "Print" = "exec grim";
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
      seat * xcursor_theme catppuccin-macchiato-dark-cursors 20
      exec_always xrandr --output HDMI-A-2 --primary
      exec systemctl --user import-environment XDG_SESSION_TYPE XDG_CURRENT_DESKTOP BROWSER EDITOR PATH XCURSOR_PATH COLORTERM TERM TERMINAL
      exec dbus-update-activation-environment WAYLAND_DISPLAY
    '';
  };
}

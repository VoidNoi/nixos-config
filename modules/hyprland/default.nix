{ pkgs, inputs, NIXCONFIG, username, ... }: 
let
  inherit (inputs) hyprland;
  hyprlandPath = "${NIXCONFIG}/modules/hyprland";
  #startupScript = pkgs.pkgs.writeShellScriptBin "start" ''
  #  ${pkgs.waybar}/bin/waybar &
  #  ${pkgs.swww}/bin/swww init &
  #
  #  ${pkgs.dunst}/bin/dunst &
  #  ${pkgs.hyprland}/bin/hyprctl setcursor Catppuccin-Macchiato-Dark-Cursors 20
  #  
  #  sleep 2000

  #  ${pkgs.wlr-randr}/bin/xrandr --output HDMI-A-2 --primary
  #'';
in
{

  home.packages = with pkgs; [
    libnotify
    swww
    grim
    slurp
    wl-clipboard
    wlr-randr
  ];
  
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {

      monitor = [
        "HDMI-A-2,1920x1080@60,0x0,1"
	      "HDMI-A-1,1920x1080@60,1920x0,1"
      ];
      windowrulev2 = [
        "stayfocused,class:(steam),title:'(^$)'"
        "float,class:(floorp)$,title:^(Picture-in-Picture)$"
	      "float,class:(steam)$,title:^(Friends List)$"
	      "float,class:(pavucontrol)$,title:^(Control de volumen)$"
	      "float,class:(steam)$,title:^(Steam Settings)$"
	      "float,class:(steam)$,title:^(Add Non-Steam Game)$"
	      "float,class:(xdg-desktop-portal-gtk)$,title:^(Pick game to add)$"
	      "tile,class:(DesktopEditors)$,title:^(DesktopEditors)$"
	      "float,class:(thunar)$,title:^(Progreso de las operaciones de archivo)$"
        "opacity 0.0 override,class:^(xwaylandvideobridge)$"
        "noanim,class:^(xwaylandvideobridge)$"
        "noinitialfocus,class:^(xwaylandvideobridge)$"
        "maxsize 1 1,class:^(xwaylandvideobridge)$"
        "noblur,class:^(xwaylandvideobridge)$"
      ];
      
      input = {
	      kb_layout = "es";
	      follow_mouse = "1";
	      sensitivity = "0";
      };

      general = {
        gaps_in = "3";
	      gaps_out = "5";
	      border_size = "2";
	      
	      "col.active_border" = "rgba(c3b1e1ee)";
	      "col.inactive_border" = "rgba(595959aa)";
	      
	      layout = "dwindle";
	      allow_tearing = "false";
      };
      
      decoration = {
        rounding = "5";
	      blur = {
          enabled = "true";
	        size = "3";
	        passes = "1";
	      };
	      drop_shadow = "yes";
	      shadow_range = "4";
	      shadow_render_power = "3";
	      "col.shadow" = "rgba(1a1a1aee)";
      };
      
      animations = {
        enabled = "yes";
	      bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
	      animation = [
	        "windows, 1, 7, myBezier"
	        "windowsOut, 1, 7, default, popin 80%"
	        "border, 1, 10, default"
	        "borderangle, 1, 8, default"
	        "fade, 1, 7, default"
	        "workspaces, 1, 6, default"
	      ];
      };
      
      "$mod" = "SUPER";
      bind = [
        "$mod, RETURN, exec, kitty"
	      "$mod, N, exec, thunar"
        "$mod, W, exec, floorp"
	      "$mod, D, exec, rofi -show drun -show-icons"
	      "$mod SHIFT, P, exec, grim -l 0 -g \"$(slurp)\""
        
	      "$mod, E, togglesplit,"
	      "$mod, C, killactive,"
	      "$mod SHIFT, SPACE, togglefloating,"
	      "$mod, F, fullscreen"
        
	      "$mod, G, togglegroup"
	      "$mod, right, changegroupactive, f,"
	      "$mod, left, changegroupactive, b,"
        
        "$mod SHIFT, left, movewindow, l"
        "$mod SHIFT, right, movewindow, r"
        "$mod SHIFT, up, movewindow, u"
        "$mod SHIFT, down, movewindow, d"
        "$mod SHIFT, left, movewindow, mon:l,"
        "$mod SHIFT, right, movewindow, mon:r,"

	      "SUPERCTRL, comma, movecurrentworkspacetomonitor, l"
	      "SUPERCTRL, period, movecurrentworkspacetomonitor, r"
        
	      "$mod, left, movefocus, l"
	      "$mod, right, movefocus, r"
	      "$mod, up, movefocus, u"
	      "$mod, down, movefocus, d"
        
	      "$mod, 1, workspace, 1" 
	      "$mod, 2, workspace, 2" 
	      "$mod, 3, workspace, 3" 
	      "$mod, 4, workspace, 4" 
	      "$mod, 5, workspace, 5" 
	      "$mod, 6, workspace, 6" 
	      "$mod, 7, workspace, 7" 
	      "$mod, 8, workspace, 8" 
	      "$mod, 9, workspace, 9" 
	      "$mod, 0, workspace, 10"
        
	      "$mod SHIFT, 1, movetoworkspace, 1"
	      "$mod SHIFT, 2, movetoworkspace, 2"
	      "$mod SHIFT, 3, movetoworkspace, 3"
	      "$mod SHIFT, 4, movetoworkspace, 4"
	      "$mod SHIFT, 5, movetoworkspace, 5"
	      "$mod SHIFT, 6, movetoworkspace, 6"
	      "$mod SHIFT, 7, movetoworkspace, 7"
	      "$mod SHIFT, 8, movetoworkspace, 8"
	      "$mod SHIFT, 9, movetoworkspace, 9"
	      "$mod SHIFT, 0, movetoworkspace, 10"
        
	      "$mod, mouse_down, workspace, e+1"
	      "$mod, mouse_up, workspace, e-1"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
      
      #exec-once = ''${startupScript}/bin/start'';
      exec-once = [
        "waybar &"
        "swww init &"
        "swww img ${hyprlandPath}/wallpaper.png &"
        "dunst &"
        "hyprctl setcursor Catppuccin-Macchiato-Dark-Cursors 20 &"
        "xrandr --output HDMI-A-2 --primary &"
        "logseq"
      ];
    };
  };
} 

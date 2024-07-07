{ pkgs, ... }:
{

  home.packages = [
    pkgs.picom
  ];

  services.picom = {
    enable = false;
    shadow = true;
    fade = true;
    inactiveOpacity = 1;
    vSync = true;
    settings = {
      shadow-offset-x = -7;
      shadow-offset-y = -7;
      shadow-radius = 7;
      fade-in-step = 0.03;
      fade-out-step = 0.03;
      frame-opacity = 0.9;
      inactive-opacity-override = false;
      corder-radius = 15;
#      rounded-corners-exclude = [
#        "window_type = 'dock'"
#	"window_type = 'desktop'"
#      ];
#      blur-kern = "3x3box";
#      blur-background-exclude = [
#        "window-type = 'dock'"
#	"window-type = 'desktop'"
#	"_GTK_FRAME_EXTENTS@:c"
#      ];
      mark-wmwin-focused = true;
      mark-ovredir-focused = true;
      detect-rounded-corners = true;
      detect-client-opacity = true;
      detect-transient = true;
      glx-no-stencil = true;
      use-damage = true;
      log-level = "warn";
    };
    backend = "glx";
    shadowExclude = [
      "name = 'Notification'"
      "class_g ?= 'Notify-osd'"
      "class_g = 'firefox'"
      "_GTK_FRAME_EXTENTS@:c"
    ];
    wintypes = {
      tooltip = { fade = true; shadow = true; opacity = 0.75; focus = true; full-shadow = false; };
      dock = { shadow = false; clip-shadow-above = true; };
      dnd = { shadow = false; };
      popup_menu = { opacity = 0.8; };
      dropdown_menu = { opacity = 0.8; };
    };
  };
}

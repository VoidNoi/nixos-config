{ pkgs, username, ... }:
{

  imports = [
    ./waybar-theme.nix
  ];
  
  home.packages = with pkgs; [
    cmus
    playerctl
  ];

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        #height = 30;
        output = [
          "HDMI-A-1"
          "HDMI-A-2"
        ];
        modules-left = [ "sway/workspaces" ];
        modules-center = [ "sway/window" ];
        modules-right = [ "custom/spotify" "custom/cmus" "pulseaudio" "temperature" "battery" "clock" "tray" ];

        "sway/window" = {
	        max-length = 70;
	        separate-outputs = true;
	      };

        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
	        format = "{icon}";
	        format-icons = {
	          "default" = "";
	          #"active" = "";
	          "focused" = "";
	          "urgent" = "";
	        };
	        persistent-workspaces = {
	          "1" = [];
	          "2" = [];
	          "3" = [];
	          "4" = [];
	          "5" = [];
	          "6" = [];
	          "7" = [];
	          "8" = [];
	          "9" = [];
	          "10" = [];
	        };
        };

        "battery" = {
		      states = {
			      "good" = 95;
			      "warning" = 30;
			      "critical" = 15;
		      };
		      format = "{icon} {capacity}%";
		      format-icons = [
			      ""
			      ""
			      ""
			      ""
			      ""
		      ];
	      };
          
	      "pulseaudio" = {
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
          };
          on-click = "pavucontrol";
        };

        "clock" = {
   	      tooltip-format = "{:%Y-%m-%d | %H:%M}";
          format-alt = "{:%Y-%m-%d}";
	      };

  	    "custom/cmus" = {
  	      format = "♪ {}";
  	      #max-length = 15;
  	      interval = 10;
  	      exec = "cmus-remote -C \"format_print '%a - %t'\""; # artist - title
  	      exec-if = "pgrep cmus";
  	      on-click = "cmus-remote -u";                      #toggle pause
  	      escape = true;                                    #handle markup entities
        };

	      "custom/spotify" = {
	        exec-if = "pgrep spotify";
          exec = "playerctl -p spotify -a metadata --format '{\"text\": \"{{artist}} - {{markup_escape(title)}}\", \"tooltip\": \"{{playerName}} : {{markup_escape(title)}}\", \"alt\": \"{{status}}\", \"class\": \"{{status}}\"}' -F";
          format = "  {}";
          return-type = "json";
          on-click = "playerctl -p spotify play-pause";
          on-scroll-up = "playerctl -p spotify next";
          on-scroll-down = "playerctl -p spotify previous";
        };
      };
    };
  };
}

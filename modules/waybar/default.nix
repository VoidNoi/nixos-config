{ pkgs, ... }:
{

  imports = [
    ./waybar-theme.nix
  ];
  
  home.packages = with pkgs; [
    playerctl
    emacs-all-the-icons-fonts
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
          "LVDS-1"
        ];
        modules-left = [ "sway/workspaces" ];
        modules-center = [ "custom/spotify" "mpd" ];
        modules-right = [ "pulseaudio" "battery" "network" "clock" "tray" ];

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
		      format = "{icon}  {capacity}%";
		      format-icons = [
			      ""
			      ""
			      ""
			      ""
			      ""
		      ];
	      };
          
        "network" = {
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "";
          format-disconnected = "Disconnected ";
        };
        
	      "pulseaudio" = {
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-icons = {
            headphone = " ";
            hands-free = " ";
            headset = " ";
            phone = " ";
            portable = " ";
            car = " ";
            default = [" " " " " "];
          };
          on-click = "pavucontrol";
        };

        "clock" = {
   	      tooltip-format = "{:%Y-%m-%d | %H:%M}";
          format-alt = "{:%Y-%m-%d}";
	      };

        "mpd" = {
	        format = "{stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}{artist} - {title} [{elapsedTime:%M:%S}-{totalTime:%M:%S}]";
	        format-disconnected = "";
	        format-stopped = "{consumeIcon}{randomIcon}{repeatIcon}{singleIcon}Stopped";
	        interval = 2;
	        consume-icons = {
		        "on" = " ";
	        };
	        random-icons = {
		        "on" = " ";
	        };
	        repeat-icons = {
		        "on" = " ";
	        };
	        single-icons = {
		        "on" = "1 ";
	        };
	        state-icons = {
		        "paused" = " ";
		        "playing" = " ";
	        };
          on-click = "rmpc togglepause";
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

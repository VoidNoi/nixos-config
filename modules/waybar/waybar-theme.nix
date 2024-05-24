{ ... }:
{
  programs.waybar.style = ''
    * {
      font-family: FontAwesome, Roboto, Helvetica, Arial, sans-serif;
      font-size: 13px;
      padding: 0;
    }
    
    window#waybar {
      background-color: transparent;
    }

    window#waybar > box {
      margin: 2px 2px 0 2px;
    }
 
    window#waybar.empty #window {
      background: none;
    }

    #clock,
    #temperature,
    #pulseaudio,
    #custom-cmus,
    #custom-spotify,
    #tray,
    #window,
    #workspaces {
      font-family: Roboto;
      border-radius: 5px;
      padding: 0 10px;
      background-color: rgba(30, 30, 46, 0.8);
      margin: 0 2px;
    }

    #workspaces {
      padding: 0 5px;
    }

    #workspaces button {
      padding: 0 3px 0 0;
      margin: 0;
      border-radius: unset;
    }
    
    #workspaces button.empty {
      color: #414a4c;
    }
    
    #workspaces button.active {
      color: #ffffff;
    }

    #workspaces button.visible {
      color: #cfcfc4;
    }
    
    #workspaces button.urgent {
      color: #ff6961;
    }

  '';
}

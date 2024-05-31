{ username, ... }:
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
      all: initial;
      padding: 2px 5px 2px 5px;
      margin: 0;
      border-radius: unset;
      color: #b5b5ad;
    }
    
    button:hover {
      box-shadow: none; /* Remove predefined box-shadow */
      text-shadow: none; /* Remove predefined text-shadow */
      background: none; /* Remove predefined background color (white) */
      transition: none; /* Disable predefined animations */
    }
    
    #workspaces button.focused {
      color: #ffffff;
    }

    #workspaces button.visible {
      color: #ffffff;
    }

    #workspaces button.persistent {
      color: #414a4c;
    }
    
    #workspaces button.urgent {
      color: #ff6961;
    }

  '';
}

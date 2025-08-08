{ ... }:
{
  programs.rmpc = {
    enable = true;
    config = (builtins.readFile ./config);
  };

  xdg.desktopEntries = {
    rmpc = {
      name = "rmpc";
      exec = "rmpc";
      terminal = true;
      type = "Application";
      comment = "rmpc";
    };
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
}

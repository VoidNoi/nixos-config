{ ... }:
{
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = "nixos_small";
      };
      modules = [
        "title"
        "separator"
        "os"
        "shell"
        "wm"
        "font"
        "terminal"
        "uptime"
        "colors"
      ];
    };
  };
}

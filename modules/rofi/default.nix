{ username, ... }:
{
  imports = [
    ./theme.rasi.nix
  ];

  programs.rofi = {
    enable = true;
    extraConfig = {
      modi = "run,drun,window";
      icon-theme = "Zafiro-icons-Dark";
      show-icons = true;
      terminal = "kitty";
      drun-display-format = "{icon} {name}";
      location = 0;
      disable-history = false;
      hide-scrollbar = true;
      display-drun = "   Apps ";
      display-run = "   Run ";
      display-window = " 﩯  Window";
      display-Network = " 󰤨  Network";
      sidebar-mode = true;
    };

  };
}

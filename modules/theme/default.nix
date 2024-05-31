{self, lib, config, username, pkgs, ... }: {
 
  home.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    siji
    font-awesome
    unifont
    nerdfonts
    dejavu_fonts
    catppuccin-cursors
  ];

  gtk = {
    enable = true;
    iconTheme = {
      name = "Zafiro-icons-Dark";
      package = pkgs.zafiro-icons;
    };
    cursorTheme = {
      name = "Catppuccin-Macchiato-Dark-Cursors";
      package = pkgs.catppuccin-cursors.macchiatoDark;
      size = 20;
    };
    theme = {
      name = "Catppuccin-Macchiato-Standard-Mauve-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "mauve" ];
        size = "standard";
        variant = "macchiato";
      };
    };
  };
  
  xdg.configFile = {
    "gtk-4.0/assets".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
    "gtk-4.0/gtk.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
    "gtk-4.0/gtk-dark.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
  };

}

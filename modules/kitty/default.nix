{ pkgs, ... }:
{
  home.packages = with pkgs; [
    kitty
    w3m
    git
    vim
    wget
    htop
    eza
    usbutils
    yarn
  ];

  programs.kitty = {
    enable = true;
    settings = {
      background_opacity = "0.9";
      dynamic_background_opacity = "yes";
      symbol_map = "U+1F427 SerenityOS Emoji";
    };
    font.name = "Mononoki Nerd Font Mono";
    themeFile = "Catppuccin-Mocha";
  };
}

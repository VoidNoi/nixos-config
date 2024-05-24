{ pkgs, ... }:
{
  home.packages = with pkgs; [
    kitty
    neofetch
    w3m
    git
    vim
    wget
    htop
    eza
    usbutils
    yarn
    gcc
    (ranger.override { imagePreviewSupport = true; })
    ueberzug
  ];

  programs.kitty = {
    enable = true;
    settings = {
      background_opacity = "0.9";
      dynamic_background_opacity = "yes";
    };
    theme = "Catppuccin-Mocha";
  };
}

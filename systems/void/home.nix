{pkgs, ... }: {
  imports = [
    ../homeConfig.nix
  ];
 
  home.packages = with pkgs; [
    telegram-desktop
    droidcam
    gimp
    tor-browser-bundle-bin
    transmission_4-gtk
    protontricks
    revanced-cli
    element-desktop
    nix-prefetch-git
    xwaylandvideobridge 
    geteltorito
    ddrescue
    lutris
    wineWowPackages.waylandFull
    prismlauncher
    vesktop
    kicad
  ];
}

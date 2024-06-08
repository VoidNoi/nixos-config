{pkgs, ... }: {
  imports = [
    ../homeConfig.nix
  ];
 
  home.packages = with pkgs; [
    telegram-desktop
    droidcam
    gimp
    tor-browser-bundle-bin
    transmission-gtk
    protontricks
    revanced-cli
    element-desktop
    nix-prefetch-git
    xwaylandvideobridge 
    geteltorito
    ddrescue
    floorp
    lutris
    wineWowPackages.waylandFull
    prismlauncher
  ];
}

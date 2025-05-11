{pkgs, pkgs-stable, ... }: {
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
    kdePackages.xwaylandvideobridge 
    geteltorito
    ddrescue
    pkgs-stable.lutris
    prismlauncher
    vesktop
    kicad-small
    ani-cli
    pkgs-stable.wineWowPackages.waylandFull
  ];
}

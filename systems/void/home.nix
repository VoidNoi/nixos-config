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
    kdePackages.xwaylandvideobridge 
    geteltorito
    ddrescue
    lutris
    prismlauncher
    vesktop
    kicad-small
    ani-cli
    wineWowPackages.waylandFull
    orca-slicer
    freecad-wayland
    blender
    davinci-resolve-studio-paid
  ];
}

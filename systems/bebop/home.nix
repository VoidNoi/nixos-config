{pkgs, ... }: {
  imports = [
    ../homeConfig.nix
  ];
 
  home.packages = with pkgs; [
    brightnessctl
    dbeaver-bin
  ];
}

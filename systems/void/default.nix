{ config, pkgs, inputs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.extraModulePackages = with config.boot.kernelPackages; [v4l2loopback];
  boot.kernelModules = ["v4l2loopback"];
 
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.noi = {
    isNormalUser = true;
    description = "noi";
    extraGroups = [ "networkmanager" "wheel" "dialout" "scanner" "lp" ];
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "noi" = import ./home.nix;
    };
  };

  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.hplipWithPlugin ];
  };

  services = {
    printing = {
      enable = true;
      drivers = with pkgs; [ hplip ];
    };

  };
  
  programs = {
    #hyprland = {
    #  enable = true;
    #  xwayland = {
    #    enable = true;
    #  };
    #  portalPackage = pkgs.xdg-desktop-portal-hyprland;
    #  package = inputs.hyprland.packages."${pkgs.system}".hyprland; 
    #};
    
    system-config-printer.enable = true;
  };

  users.defaultUserShell = pkgs.zsh; 

  environment.systemPackages = with pkgs; [
    v4l-utils
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
 
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  #system.stateVersion = "23.11"; # Did you read the comment?

}

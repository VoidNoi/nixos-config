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

    syncthing = {
      enable = true;
      user = "noi";
      #dataDir = "/home/noi/Default Folder";    # Default folder for new synced folders
      configDir = "/home/noi/.config/syncthing"; 
      settings = {
        devices = {
	        "Pi" = { id = "SIBON2Z-FYVVPAG-TQUG2JU-43BEVSV-ALKQL6W-5UKYAJ5-WO2PSCG-NVI22AM"; };
	        "Phone" = { id = "6ZGQXN3-TC3EX7K-QLNF4GH-WOSQG7Z-DJF63QR-LOCCD5P-BS525FX-AO55RAB"; };
	      };
	      folders = {
	        "Obsidian Vault" = {
	          path = "/home/noi/Obsidian Vault";
	          devices = [ "Pi" "Phone" ];
	        };
	        "scripts" = {
	          path = "/home/noi/scripts";
	          devices = [ "Pi" "Phone" ];
	        };
	      };
      };
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

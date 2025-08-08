{
  description = "Nixos config flake";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/master";
    
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    #hyprland = {
      #url = "github:hyprwm/Hyprland";
      #inputs.nixpkgs.follows = "nixpkgs";
    #};
    #spicetify-nix = {
      #url = "github:Gerg-L/spicetify-nix";
      #inputs.nixpkgs.follows = "nixpkgs";
    #};
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, /*spicetify-nix,*/ ... }: let
    
    NIXCONFIG = "~/nixConfig";
    system = "x86_64-linux";

  in {
    
    nixosConfigurations = {
      void = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          hostname = "void";
          username = "noi";
          deviceName = "Bebop";
          devices = {
            "Bebop" = { id = "TFQD2FE-DKNMTQY-3KI2D4U-3XAALVL-GPNKQ7P-77AW5IG-5TONBDS-P7LZAQ7"; };
	          "Phone" = { id = "6ZGQXN3-TC3EX7K-QLNF4GH-WOSQG7Z-DJF63QR-LOCCD5P-BS525FX-AO55RAB"; };
         	  "Server" = { id = "WWR5KN6-KLEHBA7-KT76VHH-YWIJBWR-WUHHD5K-53JBP4B-VY3WNAI-EN6AHA5"; };
          };

          inherit inputs;
        };
        modules = [
          ./systems/void
          ./systems/mainConfig.nix
	        home-manager.nixosModules.home-manager
	        {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              username = "noi";
              hostname = "void";
              monitors = {
                HDMI-A-1 = {
                  mode = "1920x1080@60Hz";
                  pos = "1920 0";
                  bg = "${NIXCONFIG}/modules/sway/wallpaper.png fill";
                };
                
                HDMI-A-2 = {
                  mode = "1920x1080@60Hz";
                  pos = "0 0";
                  bg = "${NIXCONFIG}/modules/sway/wallpaper.png fill";
                };
              };
              inherit NIXCONFIG;

              #inherit spicetify-nix;
            };
            home-manager.users.noi = import ./systems/void/home.nix;
          }
        ];
      };
      bebop = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          hostname = "bebop";
          username = "ed";
          deviceName = "Void";
          devices = {
            "Void" = { id = "KYNSLHY-UD4VK7V-DBEYRZN-5DHHLCK-J2MYS27-I4Q7DJE-NZ55XBV-BLZLEQX"; };
	          "Phone" = { id = "6ZGQXN3-TC3EX7K-QLNF4GH-WOSQG7Z-DJF63QR-LOCCD5P-BS525FX-AO55RAB"; };
	          "Server" = { id = "WWR5KN6-KLEHBA7-KT76VHH-YWIJBWR-WUHHD5K-53JBP4B-VY3WNAI-EN6AHA5"; };
          };

          inherit inputs;
        };
        modules = [
          ./systems/bebop
          ./systems/mainConfig.nix

	        home-manager.nixosModules.home-manager
	        {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              username = "ed";
              hostname = "bebop";
              monitors = {
                LVDS-1 = {
                  mode = "1600x900";
                  pos = "0 0";
                  bg = "${NIXCONFIG}/modules/sway/wallpaper.png fill";
                }; 
              };
              inherit NIXCONFIG;

              #inherit spicetify-nix;
            };
            home-manager.users.ed = import ./systems/bebop/home.nix;
          }
        ];
      };
    };
  };
}

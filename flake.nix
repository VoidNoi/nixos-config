{
  description = "Nixos config flake";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    #hyprland = {
    #  url = "github:hyprwm/Hyprland";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    nur.url = "github:nix-community/NUR";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, nur, ... }: let 
  NIXCONFIG = "~/nixConfig";
  system = "x86_64-linux";
  in {
    nixosConfigurations = {
      void = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          hostname = "void";
          username = "noi";
          inherit inputs;
        };
        modules = [
          ./systems/void
          ./systems/mainConfig.nix
          nur.nixosModules.nur
          ({ config, ... }: {
            environment.systemPackages = [ config.nur.repos.nltch.spotify-adblock ];
          })
	        home-manager.nixosModules.home-manager
	        {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              username = "noi";
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
          inherit inputs;
        };
        modules = [
          ./systems/bebop
          ./systems/mainConfig.nix
          nur.nixosModules.nur
          ({ config, ... }: {
            environment.systemPackages = [ config.nur.repos.nltch.spotify-adblock ];
          })
	        home-manager.nixosModules.home-manager
	        {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              username = "ed";
              monitors = {
                LVDS-1 = {
                  mode = "1600x900";
                  pos = "0 0";
                  bg = "${NIXCONFIG}/modules/sway/wallpaper.png fill";
                }; 
              };
              inherit NIXCONFIG;
            };
            home-manager.users.ed = import ./systems/bebop/home.nix;
          }
        ];
      };
    };
  };
}

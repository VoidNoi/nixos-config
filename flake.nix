{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, nur, hyprland, ... }: {
    nixosConfigurations = {
      void = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux"; 
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          nur.nixosModules.nur
          ({ config, ... }: {
            environment.systemPackages = [ config.nur.repos.nltch.spotify-adblock ];
          })
	  home-manager.nixosModules.home-manager
	  {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.noi = import ./home.nix;
          }
	  hyprland.nixosModules.default
        ];
      };
    };
  };
}

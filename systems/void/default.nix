{ config, pkgs, inputs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      #./vfio/vfio.nix
    ];

  # Bootloader.
  boot.extraModulePackages = with config.boot.kernelPackages; [v4l2loopback];
  boot.kernelModules = [ "v4l2loopback" "kvm-amd" "vfio-pci" ];
 
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.noi = {
    isNormalUser = true;
    description = "noi";
    extraGroups = [ "networkmanager" "wheel" "dialout" "scanner" "lp" "libvirtd" ];
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

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      mesa.opencl # Enables Rusticl (OpenCL) support
     rocmPackages.clr.icd
    ];
  };
  
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

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
    virt-manager
    v4l-utils
    virt-viewer
  ];

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [ pkgs.OVMFFull.fd ];
      };
    };
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  environment.sessionVariables = {
    ROC_ENABLE_PRE_VEGA= 1;
    RUSTICL_ENABLE= "amdgpu,amdgpu-pro,radv,radeon,radeonsi";
    DRI_PRIME= 1;
  };
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  #system.stateVersion = "23.11"; # Did you read the comment?

}

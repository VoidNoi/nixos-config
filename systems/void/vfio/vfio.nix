{ config, pkgs, ... }: let

  vfioPath = "/home/noi/nixConfig/systems/void/vfio";
  
in {
  # Boot configuration
  boot.kernelParams = [ "amd_iommu=on" "iommu=pt" ];
 
  # User accounts
  #users.users.noi = {
  #  extraGroups = [ "libvirtd" ];
  #};
 
  # Enable libvirtd
  #virtualisation.libvirtd = {
  #  enable = true;
  #  onBoot = "ignore";
  #  onShutdown = "shutdown";
  #  qemu = {
  #    ovmf.enable = true;
  #    runAsRoot = true;
  #  };
  #};
  
  virtualisation = {
    spiceUSBRedirection.enable = true;
  };
  services.spice-vdagentd.enable = true;
  
  # Add binaries to path so that hooks can use it
  systemd.services.libvirtd = {
    path = let
      env = pkgs.buildEnv {
        name = "qemu-hook-env";
        paths = with pkgs; [
          bash
          libvirt
          kmod
          systemd
          ripgrep
          sd
        ];
      };
    in
      [ env ];
    preStart =
    ''
      mkdir -p /var/lib/libvirt/hooks
      mkdir -p /var/lib/libvirt/hooks/qemu.d/win10/prepare/begin
      mkdir -p /var/lib/libvirt/hooks/qemu.d/win10/release/end
      
      ln -sf ${vfioPath}/qemu /var/lib/libvirt/hooks/qemu
      ln -sf ${vfioPath}/start.sh /var/lib/libvirt/hooks/qemu.d/win10/prepare/begin/start.sh
      ln -sf ${vfioPath}/revert.sh /var/lib/libvirt/hooks/qemu.d/win10/release/end/revert.sh
    '';
  };
 
      #chmod +x /var/lib/libvirt/hooks/qemu
      #chmod +x /var/lib/libvirt/hooks/qemu.d/win10/prepare/begin/start.sh
      #chmod +x /var/lib/libvirt/hooks/qemu.d/win10/release/end/revert.sh
  # Link hooks to the correct directory
  #system.activationScripts.libvirt-hooks.text =
  #''
  #  ln -Tfs /etc/libvirt/hooks /var/lib/libvirt/hooks
  #'';
 
  # Enable xrdp
  #services.xrdp.enable = true; # use remote_logout and remote_unlock
  #services.xrdp.defaultWindowManager = "sway";
  #systemd.services.pcscd.enable = false;
  #systemd.sockets.pcscd.enable = false;
 
  # VFIO Packages installed
  environment.systemPackages = with pkgs; [
    #virt-manager
    #gnome3.dconf # needed for saving settings in virt-manager
    libguestfs # needed to virt-sparsify qcow2 files
    spice
    spice-gtk
    spice-vdagent
    spice-protocol
    win-virtio
    win-spice
    gnome.adwaita-icon-theme
  ];
 
  #environment.etc = {
  #  "libvirt/hooks/qemu" = {
  #    source = ./qemu;
  #    mode = "0755";
  #  };
  #  "libvirt/hooks/qemu.d/win10/prepare/begin/start.sh" = {
  #    source = ./start.sh;
  #    mode = "0755";
  #  };
  #  "libvirt/hooks/qemu.d/win10/release/end/revert.sh" = {
  #    source = ./revert.sh;
  #    mode = "0755";
  #  };
  #};      
}

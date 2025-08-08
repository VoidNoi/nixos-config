{ inputs, ... }:
{
  
  nixpkgs.overlays = [
    inputs.nur.overlays.default
    (final: prev: {

      # Add unstable packages as an overlay so that they are available in the
      # configs as `pkgs.unstable.<package-name>`
      unstable = import inputs.nixpkgs-unstable {
        system = "${prev.system}";
        config.allowUnfree = true;
      };
      # Adds a modified version of davinci-resolve-studio
      davinci-resolve-studio-paid = final.callPackage ../nixpkgs/davinci-resolve {
        desktopItem = prev.e.desktopItem.override (d: {
          exec = "ROC_ENABLE_PRE_VEGA=1 RUSTICL_ENABLE=amdgpu,amdgpu-pro,radv,radeon,radeonsi DRI_PRIME=1 QT_QPA_PLATFORM=xcb ${d.exec}";
        });
      };
      #ghidra = prev.ghidra.override (e: rec {
        #desktopItem = e.desktopItem.override (d: {
          #exec = "_JAVA_AWT_WM_NONREPARENTING=1 ghidra ${d.exec}";
        #});
      #});
    })
  ];

}

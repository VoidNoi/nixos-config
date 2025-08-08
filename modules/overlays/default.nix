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
      davinci-resolve-studio-paid = prev.callPackage ../nixpkgs/davinci-resolve {};
    })
  ];

}

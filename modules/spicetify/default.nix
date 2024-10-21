{
  pkgs,
  lib,
  spicetify-nix,
  ...
}:
{
  # import the flake's module for your system
  imports = [ spicetify-nix.homeManagerModules.default ];

  # configure spicetify :)
  programs.spicetify =
    let
      spicePkgs = spicetify-nix.legacyPackages.${pkgs.system};
    in
    {
    enable = true;
    theme = spicePkgs.themes.text;
    colorScheme = "rosepine";
    enabledExtensions = with spicePkgs.extensions; [
      fullAppDisplay
      shuffle # shuffle+ (special characters are sanitized out of ext names)
      hidePodcasts
      popupLyrics
      playlistIcons
      keyboardShortcut
      adblock
    ];
  };
}

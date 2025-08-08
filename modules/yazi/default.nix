{
  config,
  lib,
  pkgs,
  userSettings,
  ...
}:

let
  yazi-plugins = pkgs.fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "main";
    hash ="sha256-m3709h7/AHJAtoJ3ebDA40c77D+5dCycpecprjVqj/k=";
  };
in {
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "y";
    initLua = '' 
        require("full-border"):setup {
           -- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
           type = ui.Border.ROUNDED,                           
        }
        require("git"):setup()
         '';
    plugins = {
      mount = "${yazi-plugins}/mount.yazi";
      full-border = "${yazi-plugins}/full-border.yazi";
      jump-to-char = "${yazi-plugins}/jump-to-char.yazi";
      git = "${yazi-plugins}/git.yazi";
      restore = pkgs.fetchFromGitHub {
        owner = "boydaihungst";
        repo = "restore.yazi";
        rev = "master";
        hash = "sha256-DPud1Mfagl2z490f5L69ZPnZmVCa0ROXtFeDbEegBBU=";
      };
    };
    keymap = {
      manager.prepend_keymap = [
        { run = "plugin mount"; on = [ "M" ]; }
        { run = ''shell 'ripdrag "$@" -x 2>/dev/null &' --confirm''; on = [ "<C-n>" ]; }
        { run = "plugin restore"; on = [ "<C-d>" "u" ]; desc = "Restore last deleted files/folders"; }
      ];
    };
    settings = {
      plugin.prepend_fetchers = [
        { id = "git"; name = "*"; run = "git"; }
        { id = "git"; name = "*/"; run = "git"; }
      ];
    };
  };
}

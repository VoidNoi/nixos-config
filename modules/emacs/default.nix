{ pkgs, NIXCONFIG, ... }: let

  emacsPath = "${NIXCONFIG}/modules/emacs";
    
in {

  programs.emacs = {
    enable = true;
    #package = pkgs.emacs29-pgtk; # Use this package if you want transparency to work
    extraConfig = ''
      ${builtins.readFile ./config.el}
      (setq dashboard-startup-banner "${emacsPath}/ouran.png")
      (load-file "${emacsPath}/arduino-cli-mode.el")
    '';
    
    extraPackages = epkgs: with epkgs; [ 
      evil
      evil-collection
      evil-commentary
      evil-goggles
      evil-smartparens
      evil-surround
      # evil-mc
      markdown-mode
      prettier-js
      nix-mode
      yaml-mode
      markdown-mode
      json-mode
      yarn-mode
      web-mode
      php-mode
      lua-mode
      python-mode
      csharp-mode
      rust-mode
      rjsx-mode
      nginx-mode
      general
      undo-tree
      which-key
      ranger
      counsel
      use-package
      company-web
      company-nixos-options
      company-nginx
      company-arduino
      company-c-headers 
      company-php
      vertico
      auto-complete
      dashboard
      marginalia
      orderless
      catppuccin-theme
      nerd-icons
      arduino-mode
      #arduino-cli-mode
      org-bullets
      org-super-agenda
      org-ql
      yasnippet
      gnuplot
      magit
      elfeed
      doom-modeline
      corfu
      cape
      yasnippet-capf
      # meow
      base16-theme
      platformio-mode
#      ccls
      kind-icon
      lsp-mode
      phpactor
      emmet-mode
      vterm
      vterm-toggle
      simple-httpd
    ];
  };
  
  services.emacs = {
    enable = true;
    startWithUserSession = "graphical"; # This allows emacsclient to use the configuration from programs.emacs
  };
}

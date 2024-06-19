{ pkgs, NIXCONFIG, username, ... }: let

  emacsPath = "${NIXCONFIG}/modules/emacs";
    
in {

  programs.emacs = {
    enable = true;
    #package = pkgs.emacs29-pgtk; # Use this package if you want transparency to work
    extraConfig = ''
      ${builtins.readFile ./config.el}
      (setq dashboard-startup-banner "${emacsPath}/ouran.png")
    '';
    
    extraPackages = epkgs: with epkgs; [ 
      evil
      evil-collection
      evil-commentary
      evil-goggles
      evil-smartparens
      evil-surround
      evil-mc
      lsp-mode
      markdown-mode
      prettier-js
      nix-mode
      yaml-mode
      markdown-mode
      json-mode
      yarn-mode
      web-mode
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
      company
      company-ctags
      company-quickhelp
      company-shell
      company-web
      company-lua
      company-nixos-options
      company-nginx
      company-arduino
      company-c-headers 
      vertico
      auto-complete
      dashboard
      marginalia
      orderless
      catppuccin-theme
      nerd-icons
      arduino-mode
      arduino-cli-mode
      org-bullets
      yasnippet
      gnuplot
    ];
  };
  
  services.emacs = {
    enable = true;
    startWithUserSession = "graphical"; # This allows emacsclient to use the configuration from programs.emacs
  };
}

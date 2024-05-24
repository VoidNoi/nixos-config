{ pkgs, config, ... }: let

  emacsPath = "${config.home.sessionVariables.NIXCONFIG}/modules/emacs";
    
in {

  home.packages = [
    pkgs.emacs-all-the-icons-fonts
  ];

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
      lsp-mode
      markdown-mode
      neotree
      multiple-cursors
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
      general
      undo-tree
      which-key
      ranger
      counsel
      use-package
      company
      company-quickhelp
      company-shell
      vertico
      auto-complete
      dashboard
      marginalia
      orderless
      catppuccin-theme
      all-the-icons
      arduino-mode
    ];
  };

  services.emacs = {
    enable = true;
    startWithUserSession = "graphical"; # This allows emacsclient to use the configuration from programs.emacs
  };
}

{ pkgs, inputs, username, hostname, ...}: let
  history = 1000000;

in {
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    history = {
      path = "/home/${username}/.zsh_history";
      save = history;
      size = history;
    };

    plugins = [
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "master";
          sha256 = "03r6hpb5fy4yaakqm3lbf4xcvd408r44jgpv4lnzl9asp4sb9qc0";
        };
      }
      {
        name = "zsh-completions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-completions";
          rev = "master";
          sha256 = "sha256-GFHlZjIHUWwyeVoCpszgn4AmLPSSE8UVNfRmisnhkpg=";
        };
      }
      {
        name = "zsh-autosuggestions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "master";
          sha256 = "1g3pij5qn2j7v7jjac2a63lxd97mcsgw6xq6k5p7835q9fjiid98";
        };
      }
    ];

    shellAliases = {
      ls = "exa --color=auto --icons";
      grep="grep --color=auto";
      egrep="egrep --color=auto";
      fgrep="fgrep --color=auto";

      cp="cp -i";
      mv="mv -i";
      rm="rm -i";
      emacs="emacsclient -c -a 'emacs'";
      kicad="GTK_THEME=Arc-Darker kicad";
      
      pimaster="ssh pi@192.168.1.144";
      pinode="ssh pi@192.168.1.145";
      restart="systemctl --user restart";
      nixconf="cd ~/nixConfig/";
      rebuild="sudo nixos-rebuild switch --flake \"$HOME/nixConfig/#${hostname}\"";
    };
    initContent = ''
      source ${./penguin-prompt.zsh-theme}
      source <(fzf --zsh)

      bindkey '^ ' autosuggest-accept

      bindkey "^[[1;5C" forward-word
      bindkey "^[[1;5D" backward-word
      bindkey "^[[3~" delete-char

      export RMM_PATH="$HOME/Games/RimWorld"
      export PATH="$HOME/.config/emacs/bin:$PATH"
      export EDITOR="emacsclient -c -a 'emacs'"
    '';
  };
}

{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    bat
    fzf
    git
    gradle
    jq
    lazygit
    nodejs_22
    python3
    ripgrep
    unzip
    wget
    zip
  ];
  programs = {
    zsh = {
      enable = true;
      autocd = true;
      autosuggestion.enable = true;
      historySubstringSearch = {
        enable = true;
        searchDownKey = "^[[B";
        searchUpKey = "^[[A";
      };
      antidote = {
        enable = true;
        plugins = [
          # Integral Prompt release
          # "readf0x/integral-prompt"
        ];
      };
      shellAliases = {
        cat = "bat";
        grep = "rg";
        hyc = "hyprctl";
        icat = "kitten icat --align left";
        la = "eza -a";
        ll = "eza -l";
        ls = "eza";
        lt = "eza -T";
        neofetch = "fastfetch";
        open = "xdg-open";
        zshr = "exec zsh";
      };
      localVariables = {
        MANPAGER = "sh -c 'col -bx | bat -l man -p'";
      };
      initExtraFirst = ''
        [ $KITTY_WINDOW_ID -gt 1 ] || ! [[ $KITTY_SHELL_INTEGRATION = no-rc ]] || [ $SHLVL -gt 1 ] || pokeget buizel --hide-name
        # Integral prompt development
        source $HOME/Projects/prompt/init.zsh
      '';
      initExtra = ''
        bindkey -v
        bindkey -M viins '^H' backward-kill-word
        bindkey -M viins '^[[1;5D' backward-word
        bindkey -M viins '^[[1;5C' forward-word
        bindkey '^[[H' beginning-of-line
        bindkey '^[[F' end-of-line
        autoload -U select-word-style
        select-word-style bash
        autoload -Uz +X compinit && compinit
        zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
        zstyle ':completion:*' menu select
      '';
    };
    eza = {
      enable = true;
      enableZshIntegration = true;
      git = true;
      icons = true;
      extraOptions = [
        "--group-directories-first"
        "--header"
      ];
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [
        "--cmd cd"
      ];
    };
    thefuck = {
      enable = true;
      enableZshIntegration = true;
    };
    kitty = {
      enable = true;
      font = {
        name = "Fira Code Nerd Font";
        size = 11;
      };
      theme = "Chalk";
      shellIntegration.enableZshIntegration = true;
      extraConfig = ''
        enable_audio_bell no
        visual_bell_duration 0.1
        visual_bell_color #221111
      '';
    };
    fastfetch = {
      enable = true;
    };
  };
}

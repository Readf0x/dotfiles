{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    bat
    ffmpeg
    fzf
    git
    gradle
    hyperfine
    jq
    lazygit
    microfetch
    nodejs_22
    pokeget-rs
    python3
    ripgrep
    unzip
    wget
    yt-dlp
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
          "readf0x/integral-prompt"
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
        [[ $KITTY_WINDOW_ID -gt 1 ]] || ! [[ $KITTY_SHELL_INTEGRATION = no-rc ]] || [[ $SHLVL -gt 1 ]] || pokeget buizel --hide-name
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
      theme = "Chalk";
      shellIntegration.enableZshIntegration = true;
      extraConfig = ''
        enable_audio_bell no
        visual_bell_duration 0.1
        visual_bell_color #3a2828

        disable_ligatures never
        font_family family="Maple Mono" features="+cv03 +cv04 +ss01 +ss02 +ss03 +ss04 +ss05"
        font_size 11
        symbol_map U+2320-U+2321,U+239B-U+23B3 NotoSansMath-Regular
      '';
    };
    fastfetch = {
      enable = true;
    };
  };
}

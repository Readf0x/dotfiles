{ pkgs, conf, ... }: {
  home = {
    packages = with pkgs; [
      bat
      ffmpeg
      fzf
      hyfetch
      hyperfine
      jq
      microfetch
      nodejs-slim
      pokeget-rs
      python3
      ripgrep
      unzip
      wget
      yt-dlp
      zip
    ];
    file.".integralrc".text = ''
      int_direnv_format() {
        if which go >/dev/null; then 
          print "%F{6}󰟓"
        else
          print "%F{3}⌁"
        fi
      }
    '';
  };
  programs = {
    zsh = {
      enable = true;
      autocd = true;
      antidote = {
        enable = true;
        plugins = [
          "readf0x/integral-prompt"
          "zdharma-continuum/fast-syntax-highlighting kind:defer"
          "zsh-users/zsh-autosuggestions kind:defer"
          "zsh-users/zsh-history-substring-search kind:defer"
        ];
      };
      shellAliases = {
        cat = "bat";
        diff = "diff --color";
        grep = "rg";
        hyc = "hyprctl";
        icat = "kitten icat --align left";
        la = "eza -a";
        ll = "eza -l";
        ls = "eza";
        lt = "eza -T";
        neofetch = "hyfetch";
        open = "xdg-open";
        v = "nixvim";
        zshr = "exec zsh";
        ":q" = "if ! [[ $SSH_CONNECTION ]]; then exit; else echo 'goodbye! :3'; sleep 1; exit; fi";
        dev = "nix develop --command zsh";
        "power!" = "poweroff";
      };
      shellGlobalAliases = { "--help" = "--help | bat -plhelp"; };
      localVariables = {
        MANPAGER = "sh -c 'col -bx | bat -l man -p'";
        GOPATH = "$HOME/.config/go";
      };
      initExtraFirst = ''
        [[ $KITTY_WINDOW_ID -gt 1 ]] || ! [[ $KITTY_SHELL_INTEGRATION = no-rc ]] || [[ $SHLVL -gt 1 ]] || pokeget ${conf.pokemon} --hide-name
        export DIRENV_LOG_FORMAT=
      '';
      initExtra = ''
        bindkey -v
        bindkey -M viins '^H' backward-kill-word
        bindkey -M viins '^[[1;5D' backward-word
        bindkey -M viins '^[[1;5C' forward-word
        bindkey '^[[H' beginning-of-line
        bindkey '^[[F' end-of-line
        bindkey '^[[A' history-substring-search-up
        bindkey '^[[B' history-substring-search-down
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
      icons = "auto";
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
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
    kitty = {
      enable = true;
      shellIntegration.enableZshIntegration = true;
      extraConfig = ''
        enable_audio_bell no
        visual_bell_duration 0.1
        visual_bell_color #3a2828

        disable_ligatures never
        font_family family="Maple Mono NF" features="+zero +cv03 +ss03"
        font_size 11
        symbol_map U+2320,U+2321,U+239B-U+23B3 Noto Sans Math

        window_padding_width 11
        tab_bar_style separator
        tab_separator " "
        tab_title_template "  {title}  "

        map ctrl+minus change_font_size all -0.5
        map ctrl+equal change_font_size all +0.5
      '';
    };
    fastfetch = {
      enable = true;
    };
    git = {
      enable = true;
      delta = {
        enable = true;
      };
      userName = conf.user;
      userEmail = conf.email;
      signing = {
        key = conf.key;
        signByDefault = true;
      };
      extraConfig = {
        commit.gpgsign = true;
        credential.helper = "${pkgs.git.override { withLibsecret = true; }}/bin/git-credential-libsecret";
        diff.algorithm = "patience";
      };
    };
    lazygit = {
      enable = true;
      settings = {
        gui = {
          nerdFontsVersion = "3";
          showFileIcons = true;
          # border = "hidden";
        };
        git.paging = {
          pager = "delta --paging=never";
        };
      };
    };
  };
}

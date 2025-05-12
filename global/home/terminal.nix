{ pkgs, conf, ... }: {
  home.file.".integralrc".text = ''
    int_direnv_format() {
      if which go >/dev/null; then 
        print "%F{6}󰟓"
      else
        print "%F{3}⌁"
      fi
    }
    # export int_vim_indicators=(
    #   ""
    # )
  '';
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
        v = "nvim";
        zshr = "exec zsh";
        ":q" = "exit";
        ":Q" = "exit";
        "q" = "exit";
        "Q" = "exit";
        dev = "nix develop --command zsh";
        "power!" = "poweroff";
      };
      localVariables = {
        MANPAGER = "sh -c 'col -bx | bat -l man -p'";
        GOPATH = "$HOME/.config/go";
      };
      initExtraBeforeCompInit = ''
        if [[ $CONTAINER_ID ]]; then
          export function compinit() {
            unfunction compinit
            autoload -Uz compinit
            compinit -i $@
          }
        fi
      '';
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
        autoload -U select-word-style && select-word-style bash
        zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
        zstyle ':completion:*' menu select

        function run() { nix run "nixpkgs#$1" -- ''+"$\{@:2} "+''}
        function db() {
          if [[ $1 = "enter" ]]; then
            distrobox enter $2 --additional-flags "--env SSH_CONNECTION=$SSH_CONNECTION" ''+"$\{@:3}"+'';
          else
            distrobox $@
          fi
        }

        alias cat=bat
        alias -g -- --help='--help | bat -plhelp'
        if [[ $VENDOR = debian ]]; then
          alias cat=batcat
          alias -g -- --help='--help | batcat -plhelp'
        fi
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
        symbol_map U+25CB-U+25D7 Ubuntu

        window_padding_width 11
        tab_bar_style separator
        tab_separator " "
        tab_title_template "  {title}  "

        map ctrl+minus change_font_size all -0.5
        map ctrl+equal change_font_size all +0.5

        allow_remote_control yes
      '';
    };
    # it is currently impossible to add singular backslashes when converting to json
    fastfetch = {
      enable = true;
      # settings = {
      #   display = {
      #     separator = " ";
      #   };
      #   modules = [
      #     {
      #       type = "title";
      #       format = ''\u001b[33m⌠ {6}{7}{8} \u001b[33m∫ \u001b[32m{3} \u001b[33m╰──────────────────────────────'';
      #     }
      #     {
      #       type = "os";
      #       key = ''\u001b[33m⎮ \u001b[36m󱄅'';
      #     }
      #     {
      #       type = "kernel";
      #       key = ''\u001b[33m⎮ \u001b[36m'';
      #     }
      #     {
      #       type = "packages";
      #       key = ''\u001b[33m⎮ \u001b[36m󰏖'';
      #       format = "{36}";
      #     }
      #     {
      #       type = "shell";
      #       key = ''\u001b[33m⎮ \u001b[36m'';
      #     }
      #     {
      #       type = "display";
      #       key = ''\u001b[33m⎮ \u001b[36m󰍹'';
      #     }
      #     {
      #       type = "wm";
      #       key = ''\u001b[33m⎮ \u001b[36m'';
      #     }
      #     {
      #       type = "cpu";
      #       key = ''\u001b[33m⎮ \u001b[36m'';
      #     }
      #     {
      #       type = "gpu";
      #       key = ''\u001b[33m⎮ \u001b[36m󰢮'';
      #     }
      #     {
      #       type = "memory";
      #       key = ''\u001b[33m⎮ \u001b[36m'';
      #     }
      #     {
      #       type = "disk";
      #       key = ''\u001b[33m⎮ \u001b[36m󱛟'';
      #       format = "{10} {1} / {2} ({3}) - {9}";
      #     }
      #     {
      #       type = "swap";
      #       key = ''\u001b[33m⌡ \u001b[36m󱛟'';
      #       format = "Swap {1} / {2} ({3})";
      #     }
      #     "break"
      #     "break"
      #     "colors"
      #   ];
      # };
    };
  };
  home.file.".config/fastfetch/config.jsonc".text = ''
    {
      "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
      "display": {
        "separator": " "
      },
      "modules": [
        {
          "type": "title",
          "format": "\u001B[33m⌠ {6}{7}{8} \u001B[33m∫ \u001B[32m{3} \u001B[33m╰──────────────────────────────"
        },
        {
          "type": "host",
          "key": "\u001B[33m⎮ \u001B[36m󰌢"
        },
        {
          "type": "os",
          "key": "\u001B[33m⎮ \u001B[36m󱄅"
        },
        {
          "type": "kernel",
          "key": "\u001B[33m⎮ \u001B[36m"
        },
        {
          "type": "packages",
          "key": "\u001B[33m⎮ \u001B[36m󰏖",
          "format": "{9} (system), {10} (user)"
        },
        {
          "type": "shell",
          "key": "\u001B[33m⎮ \u001B[36m"
        },
        {
          "type": "display",
          "key": "\u001B[33m⎮ \u001B[36m󰍹"
        },
        {
          "type": "wm",
          "key": "\u001B[33m⎮ \u001B[36m"
        },
        {
          "type": "cpu",
          "key": "\u001B[33m⎮ \u001B[36m"
        },
        {
          "type": "gpu",
          "key": "\u001B[33m⎮ \u001B[36m󰢮"
        },
        {
          "type": "memory",
          "key": "\u001B[33m⎮ \u001B[36m"
        },
        {
          "type": "disk",
          "key": "\u001B[33m⎮ \u001B[36m󱛟",
          "format": "{10} {1} / {2} ({3}) - {9}"
        },
        {
          "type": "swap",
          "key": "\u001B[33m⌡ \u001B[36m󱛟",
          "format": "Swap {1} / {2} ({3})"
        },
        "break",
        "break",
        "colors"
      ]
    }
  '';
  programs = {
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
        os.editPreset = "nvim";
      };
    };
  };
}

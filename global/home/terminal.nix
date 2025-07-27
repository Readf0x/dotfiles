{ pkgs, lib, conf, ... }: {
  # [TODO] Investigate tmux
  programs = {
    zsh = {
      enable = true;
      autocd = true;
      antidote = {
        enable = true;
        plugins = [
          "zdharma-continuum/fast-syntax-highlighting kind:defer"
          "zsh-users/zsh-autosuggestions kind:defer"
          "zsh-users/zsh-history-substring-search kind:defer"
        ];
      };
      integral-prompt = {
        enable = true;
        config = {
          modules_right = [];
          modules = [
            "nix"
            "visym"
            "error"
            "dir"
            "ssh+"
            "git"
            "jobs"
          ];
        };
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
        "power!" = "poweroff";
        time = "hyperfine";
      };
      localVariables = {
        PAGER = "bat -p";
      };
      initContent = lib.mkMerge [
        (lib.mkOrder 550 ''
          if [[ $CONTAINER_ID ]]; then
            export function compinit() {
              unfunction compinit
              autoload -Uz compinit
              compinit -i $@
            }
          fi
          autoload bashcompinit && bashcompinit
        '')
        (lib.mkBefore ''
          [[ $KITTY_WINDOW_ID -gt 1 ]] || ! [[ $KITTY_SHELL_INTEGRATION = no-rc ]] || [[ $SHLVL -gt 1 ]] || pokeget ${conf.pokemon} --hide-name
          export DIRENV_LOG_FORMAT=
        '')
        (''
          bindkey -v
          bindkey '^U' kill-whole-line
          bindkey '^H' backward-kill-word
          bindkey '^[[1;5D' backward-word
          bindkey '^[[1;5C' forward-word
          bindkey '^[[H' beginning-of-line
          bindkey '^[[F' end-of-line
          bindkey '^[[A' history-substring-search-up
          bindkey '^[[B' history-substring-search-down
          autoload -U select-word-style && select-word-style bash
          zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
          zstyle ':completion:*' menu select

          alias realnix="$(which nix)"
          function nix() {
            case "$1" in;
              build|develop|shell) nom $@ ;;
              *) realnix $@ ;;
            esac
          }
          compdef nix=nix
          function run() { realnix run nixpkgs#$1 -- ${"$\{@:2}"}}
          function surun() { sudo realnix run nixpkgs#$1 -- ${"$\{@:2}"}}
          function shell() {
            if [[ ${"$\{#@}"} > 1 ]]; then
              eval nom shell nixpkgs#{${"$\{(j:,:)@}"}}
            else
              nom shell nixpkgs#$1
            fi
          }
          function path2array() {
            local input=$1
            print -l ${"$\{(s/:/)input}"}
          }
          function spawn() {
            $@ &>/dev/null & disown
          }
          function clone() {
            source $HOME/Scripts/clone $@
          }
          function gpgmsg() {
            print "$2" | gpg --encrypt -ar "$1"
          }
          alias realman="$(which man)"
          function man() {
            realman $@ | bat -plman
          }
          compdef man=man

          alias cat=bat
          alias -g -- --help='--help | bat -plhelp'

          if [[ $VENDOR = debian ]]; then
            alias cat=batcat
            alias -g -- --help='--help | batcat -plhelp'
          else
            function db() {
              if [[ $1 = "enter" ]]; then
                distrobox enter $2 --additional-flags "--env SSH_CONNECTION=$SSH_CONNECTION" ${"$\{@:3}"};
              else
                distrobox $@
              fi
            }
            compdef db=distrobox
          fi
          if tty | grep tty &>/dev/null; then
            alias mpv="mpv --vo=drm"
          fi
        '')
      ];
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
      theme = {
        extensions = {
          tet = { icon = { glyph = ""; }; };
        };
      };
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
      config.global.log_filter = "^$";
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
        symbol_map U+25A0-U+25FF DejaVu Sans Mono

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
  programs = {
    git = {
      enable = true;
      delta = {
        enable = true;
      };
      userName = conf.user;
      userEmail = conf.email;
      signing = {
        key = conf.gpg;
        signByDefault = true;
      };
      extraConfig = {
        commit.gpgsign = true;
        credential.helper = "${pkgs.git.override { withLibsecret = true; }}/bin/git-credential-libsecret";
        diff.algorithm = "patience";
        init.defaultBranch = "master";
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
    tmux = {
      enable = true;
      aggressiveResize = true;
      keyMode = "vi";
    };
  };
  home.file = {
    ".config/hyfetch.json".text = builtins.toJSON {
      preset = "transgender";
      mode = "rgb";
      light_dark = "dark";
      lightness = 0.8;
      color_align = {
          mode = "horizontal";
          custom_colors = [];
          fore_back = null;
      };
      backend = "fastfetch";
      args = null;
      distro = null;
      pride_month_shown = [];
      pride_month_disable = true;
    };
    ".config/fastfetch/config.jsonc".text = ''
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
    ".config/bat/syntaxes/TET.sublime-syntax".text = ''
      %YAML 1.2
      ---
      name: Templating Engine Template
      file_extensions:
        - tet
      scope: text.xml.templating-engine
      contexts:
        main:
          - match: '<\|'
            scope: punctuation.section.embedded.begin.templating-engine
            push: embedded-go
          - include: scope:text.xml

        embedded-go:
          - meta_scope: source.go.embedded.templating-engine
          - meta_content_scope: source.go.embedded.templating-engine

          # End embedded Go block
          - match: '\|>'
            scope: punctuation.section.embedded.end.templating-engine
            pop: true

          # Match and highlight modifier like `:w`
          - match: ':(\w+)\b'
            captures:
              0: keyword.other.templating-engine
              1: support.function.modifier.templating-engine

          # Minimal Go syntax subset to prevent greediness
          - match: '//.*$'
            scope: comment.line.double-slash.go

          - match: '"(?:\\.|[^"\\])*"'
            scope: string.quoted.double.go

          - match: '\b(if|else|for|func|return|var|const|struct|switch|case|break|continue|default|import|package)\b'
            scope: keyword.control.go

          - match: '\b(true|false|nil)\b'
            scope: constant.language.go

          - match: '\b\d+\b'
            scope: constant.numeric.integer.go

          - match: '[a-zA-Z_]\w*'
            scope: variable.other.go

          - match: '[\[\]{}(),.;]'
            scope: punctuation.separator.go

          - match: '[-+*/%=!<>|&^]+'
            scope: keyword.operator.go
    '';
  };
}

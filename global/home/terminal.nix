{ pkgs, lib, lib', conf, config, ... }: {
  # [TODO] Investigate tmux
  home.shell.enableZshIntegration = true;
  home.shell.enableFishIntegration = true;
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
      shellAliases = {
        diff = "diff --color";
        grep = "rg";
        hyc = "hyprctl";
        icat = "kitten icat --align left";
        la = "eza -a";
        ll = "eza -l";
        ls = "eza";
        lt = "eza -T";
        neofetch = "pokeget ${lib'.pokeget conf.pokemon} --hide-name | fastfetch --file /dev/stdin";
        open = "xdg-open";
        shr = "exec zsh";
        v = "nvim";
        ":q" = "exit";
        ":Q" = "exit";
        "q" = "exit";
        "Q" = "exit";
        "power!" = "poweroff";
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
          [[ $KITTY_WINDOW_ID -gt 1 ]] || ! [[ $KITTY_SHELL_INTEGRATION = no-rc ]] || [[ $SHLVL -gt 1 ]] || pokeget ${lib'.pokeget conf.pokemon} --hide-name | fastfetch --file /dev/stdin
          export DIRENV_LOG_FORMAT=
        '')
        (''
          bindkey -v
          bindkey '^U' kill-whole-line
          if ! [[ $TERM = 'xterm-256color' ]]; then
            bindkey '^H' backward-kill-word
          fi
          bindkey '^[[1;5D' backward-word
          bindkey '^[[1;5C' forward-word
          bindkey '^[[H' beginning-of-line
          bindkey '^[[F' end-of-line
          bindkey '^[[A' history-substring-search-up
          bindkey '^[[B' history-substring-search-down
          autoload -U select-word-style && select-word-style bash
          zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
          zstyle ':completion:*' menu select

          if ! [[ -v CONTAINER_ID ]]; then
            function nix() {
              case "$1" in;
                build|develop|shell) nom $@ ;;
                remote)
                  IFS=$'\n' builders=($(cat ~/.remote-builders))
                  nom build ''${@:2} --builders "''${builders[@]}"
                ;;
                *) builtin command nix $@ ;;
              esac
            }
            compdef nix=nix
          fi
          function run() { builtin command nix run nixpkgs#$1 -- ''${@:2} }
          function surun() { sudo nix run nixpkgs#$1 -- ''${@:2} }
          function shell() {
            if [[ ''${#@} > 1 ]]; then
              eval nom shell nixpkgs#{''${(j:,:)@}}
            else
              nom shell nixpkgs#$1
            fi
          }
          function path2array() {
            local input=$1
            print -l ''${(s/:/)input}
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
          function man() {
            builtin command man $@ | bat -plman
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
                distrobox enter $2 --additional-flags "--env SSH_CONNECTION=$SSH_CONNECTION" ''${@:3};
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
    fish = {
      enable = true;
      shellAliases = {
        cat = "bat";
        diff = "diff --color";
        grep = "rg";
        hyc = "hyprctl";
        la = "eza -a";
        ll = "eza -l";
        ls = "eza";
        lt = "eza -T";
        neofetch = "pokeget ${lib'.pokeget conf.pokemon} --hide-name | fastfetch --file /dev/stdin";
        open = "xdg-open";
        print = "echo";
        shr = "exec fish";
        unset = "set -e";
        v = "nvim";
        ":q" = "exit";
        ":Q" = "exit";
        "q" = "exit";
        "Q" = "exit";
        "power!" = "poweroff";
      };
      binds = {
        ctrl-backspace = {
          mode = "insert";
          command = "backward-kill-word";
        };
      };
      # or test "$KITTY_SHELL_INTEGRATION" = no-rc
      interactiveShellInit = lib.mkAfter ''
        complete --command man --wraps man
        complete --command nix --wraps nix

        function __ssh_tab_set --on-event fish_preexec
          if test (string split ' ' -- $argv[1])[1] = ssh
            kitty @ set-tab-color active_bg=#${config.lib.stylix.colors.red}
          end
        end
        function __ssh_tab_reset --on-event fish_postexec
          if test (string split ' ' -- $argv[1])[1] = ssh
          and not set -q SSH_CONNECTION
            kitty @ set-tab-color active_bg=NONE
          end
        end
        function __exit_sig --on-event fish_postexec
          set sig $status
          if test $sig != 0
            echo (set_color brblack)Command exited (set_color red)"[$sig]"
          end
        end

        set -g fish_key_bindings fish_vi_key_bindings
        set fish_greeting (set_color magenta){$USER}(set_color brblack)@(set_color cyan){$hostname}(set_color yellow)" ∫ "(set_color green)${toString conf.homeDir}
      '';
      functions = {
        nix = ''
          switch $argv[1]
            case build develop shell
              nom $argv
            case remote
              set builders (cat ~/.remote-builders)
              nom build $argv[2..-1] --builders $builders
            case '*'
              command nix $argv
          end
        '';
        run = "command nix run nixpkgs#$argv[1] -- $argv[2..-1]";
        surun = "sudo nix run nixpkgs#$argv[1] -- $argv[2..-1]";
        shell = ''
          if test (count $argv) -gt 1
            eval nom shell nixpkgs#(string join ',' $argv)
          else
            nom shell nixpkgs#$argv[1]
          end
        '';
        spawn = "$argv >/dev/null 2>&1 & disown";
        # need to rewrite clone script...
        # clone = "source ~/Scripts/clone $argv";
        man = "command man $argv | bat -plman";
      };
    };
    integral-prompt = {
      enable = true;
      config = {
        modules_right = [
          "ssh+"
        ];
        modules = [
          "nix"
          "visym"
          "error"
          "dir"
          "git"
          "jobs"
        ];
        dir.replace = [
          [ "${toString conf.homeDir}/Repos/" "󰊢 /" ]
          [ "${toString conf.homeDir}/Repos" "󰊢" ]
        ];
      };
    };
    eza = {
      enable = true;
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
      options = [
        "--cmd cd"
      ];
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      config.global.log_filter = "^$";
    };
    kitty = {
      enable = true;
      enableGitIntegration = true;
      extraConfig = ''
        shell fish

        tab_bar_min_tabs 1

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
    git = {
      enable = true;
      signing = {
        key = conf.gpg;
        signByDefault = true;
      };
      settings = {
        user = {
          name = conf.user;
          email = conf.email;
        };
        commit.gpgsign = true;
        credential.helper = "${pkgs.git.override { withLibsecret = true; }}/bin/git-credential-libsecret";
        diff.algorithm = "patience";
        init.defaultBranch = "master";
      };
    };
    delta = {
      enable = true;
      enableGitIntegration = true;
    };
    lazygit = {
      enable = true;
      settings = {
        gui = {
          nerdFontsVersion = "3";
          showFileIcons = true;
          # border = "hidden";
        };
        git = {
          overrideGpg = true;
          paging.pager = "delta --paging=never";
        };
        os.editPreset = "nvim";
      };
    };
    tmux = {
      enable = true;
      aggressiveResize = true;
      keyMode = "vi";
    };
    fzf = {
      enable = true;
    };
  };
  home.file = {
    # ".config/hyfetch.json".text = builtins.toJSON {
    #   preset = "transgender";
    #   mode = "rgb";
    #   light_dark = "dark";
    #   lightness = 0.8;
    #   color_align = {
    #       mode = "horizontal";
    #       custom_colors = [];
    #       fore_back = null;
    #   };
    #   backend = "fastfetch";
    #   args = null;
    #   distro = null;
    #   pride_month_shown = [];
    #   pride_month_disable = true;
    # };
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
    ".remote-builders".text = conf.hosts
    |> lib.filterAttrs (n: v: v.remoteBuild.enable)
    |> lib.mapAttrsToList (n: v: "ssh://${v.ssh.shortname} ${v.system} - ${toString v.remoteBuild.jobs} ${toString v.remoteBuild.speedFactor}")
    |> lib.concatStringsSep "\n"
    ;
  };
}

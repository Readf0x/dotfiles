{ pkgs, lib, lib', conf, config, ... }: {
  # [TODO] Investigate tmux
  home.shell.enableFishIntegration = true;
  programs = {
    fish = {
      enable = true;
      shellAliases = {
        cat = "bat";
        diff = "diff --color";
        grep = "rg";
        hyc = "hyprctl";
        ls = "eza";
        la = "eza -a";
        ll = "eza -l";
        lla = "eza -la";
        llt = "eza -lT";
        llta = "eza -lTa";
        lt = "eza -T";
        lta = "eza -Ta";
        lg = "eza -lTa --git-ignore (git rev-parse --show-toplevel)";
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
        convert = "magick";
        icat = "kitten icat";
      };
      shellAbbrs = {
        "--help" = {
          position = "anywhere";
          expansion = "--help | bat -plhelp";
        };
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
          if test (string sub -e 3 $argv[1]) = ssh
            kitty @ set-tab-color active_bg=#${config.lib.stylix.colors.red}
          end
        end
        function __ssh_tab_reset --on-event fish_postexec
          if test (string sub -e 3 $argv[1]) = ssh
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
            eval nom shell nixpkgs#{(string join ',' $argv)}
          else
            nom shell nixpkgs#$argv[1]
          end
        '';
        spawn = "$argv >/dev/null 2>&1 & disown";
        man = "command man $argv | bat -plman";
        integral_pwd = ''
          set -l str $PWD
          for item in (jq -rcM '.dir.replace[]' ~/.config/integralrc.json)
            set -l pair (string replace -r '^\["(.*)","(.*)"\]$' '$1\n$2' -- $item)
            set str (string replace $pair[1] $pair[2] $str)
          end
          if test $str = $PWD
            prompt_pwd -d 1 -D 1
          else
            echo $str
          end
        '';
        fish_title = ''
          set -l ssh
          set -q SSH_TTY
          and set ssh "["(prompt_hostname | string sub -l 10 | string collect)"]"
          set -l command
          if set -q argv[1]
            set command $argv[1]
          else
            set command (status current-command)
            if test "$command" = fish
              set command
            end
          end
          set shortcmd (string split ' ' $command)[1]
          if test "$shortcmd" = v
            echo -- $ssh $command
          else
            echo -- $ssh (string sub -l 20 -- $shortcmd) (integral_pwd)
          end
        '';
        clone_parseurl = ''
          set arg $argv[1]

          if echo $arg | rg -q '/'
            if echo $arg | rg -q '^http'
              echo $arg
            else
              echo "https://github.com/$arg"
            end
          else
            echo "https://github.com/(whoami)/$arg"
          end
        '';
        clone = ''
          if test "$argv[1]" = "-h" -o "$argv[1]" = "--help"
            printf "%s\n" "
          A script for cloning git repos

          Usage: clone <REPOSITORY> [PATH] [ARGS]

          Arguments:
            <REPOSITORY>  Repository URL

            [PATH]      Root directory to clone to. Defaults to ~/Repos.

            <ARGS>      Git clone args. See git-clone(1) for more info.
          "
            return
          end

          if test -z "$argv[1]"
            echo "clone: missing repository"
            return 1
          end

          set repo_url (clone_parseurl $argv[1])
          set repo (echo $repo_url | sed -E 's|.*/([^/]+/[^/]+)(\.git)?$|\1|')

          # argv indexing:
          # $argv[2] is PATH or first arg, depending on whether it starts with -
          # remaining args must be passed through verbatim.

          if test (string match -qr '^-' -- "$argv[2]")
            # args start immediately at $argv[2]
            set sup_args $argv[2..-1]
            git clone $sup_args -- $repo_url "$HOME/Repos/$repo"
            cd "$HOME/Repos/$repo"
          else if test -e "$argv[2]"
            # path provided
            set path "$argv[2]"
            set sup_args $argv[3..-1]
            git clone $sup_args -- $repo_url "$path/$repo"
            cd "$path/$repo"
          else
            git clone $repo_url "$HOME/Repos/$repo"
            cd "$HOME/Repos/$repo"
          end
        '';
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
          tet.icon.glyph = "";
          odin = {
            icon = { glyph = "󰟢"; style = { foreground = "Yellow"; is_bold = true; }; };
            filename = { foreground = "Yellow"; is_bold = true; };
          };
          um = {
            icon = { glyph = "ü"; style = { foreground = "Yellow"; is_bold = true; }; };
            filename = { foreground = "Yellow"; is_bold = true; };
          };
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
    git = rec {
      enable = true;
      package = pkgs.gitFull;
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
        credential.helper = "${package}/bin/git-credential-libsecret";
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
          pagers = [{ pager = "delta --paging=never"; }];
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
    opencode = {
      enable = true;
      settings.provider = {
        ollama = {
          npm = "@ai-sdk/openai-compatible";
          name = "Ollama (local)";
          options.baseURL = "http://localhost:11434/v1";
          models = {
            "qwen3:8b".name = "Qwen 3 8b";
          };
        };
      };
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
    ".config/bat/syntaxes/Umka.sublime-syntax".source = "${pkgs.applyPatches {
      inherit (pkgs.this.umka) src;
      name = "umka-src-patched";
      patches = [ ./umka-bat-fix.patch ];
    }}/editors/Umka.sublime-syntax";
    ".remote-builders".text = conf.hosts
    |> lib.filterAttrs (n: v: v.remoteBuild.enable)
    |> lib.mapAttrsToList (n: v: "ssh://${v.ssh.shortname} ${v.system} - ${toString v.remoteBuild.jobs} ${toString v.remoteBuild.speedFactor}")
    |> lib.concatStringsSep "\n"
    ;
  };
}

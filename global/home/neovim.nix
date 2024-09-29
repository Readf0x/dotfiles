{ pkgs, ... }: {
  home.packages = [ pkgs.fd ];
  home.sessionVariables = { EDITOR = "nvim"; VISUAL = "nvim"; };
  programs.nixvim = {
    enable = true;
    clipboard = {
      register = "unnamedplus";
      providers = {
        wl-copy.enable = true;
        xclip.enable = true;
      };
    };

    keymaps = let 
      cmd = str: "<cmd>${str}<CR>";
      lua = s: m: {
        __raw = if m == "false" then
          "function() ${s} end"
        else "function() require('${m}').${s} end";
      };
      toggle = str: lua "${str} = not ${str}" "false";
      gitlinker = {
        line_normal = lua "vim.fn.setreg('', require('gitlinker').get_buf_range_url('n'))" "false";
        line_visual = lua "vim.fn.setreg('', require('gitlinker').get_buf_range_url('v'))" "false";
        homepage =    lua "vim.fn.setreg('', require('gitlinker').get_repo_url())" "false";
      };
      telescope_opts = [
        { cmd = "buffers";     key = "b"; name = "Buffers";     }
        { cmd = "fd";          key = "f"; name = "Files";       }
        { cmd = "live_grep";   key = "g"; name = "Search";      }
        { cmd = "grep_string"; key = "s"; name = "Search word"; }
      ];
      luasnip = x: lua "if require('luasnip').choice_active() then require('luasnip').change_choice(${x}) end" "false";
    in [
      # Remaps
      { action = "cc";                           key = "C";          mode = "n";         options.desc = "Change line";         }
      { action = "<End>";                        key = "<CR>";                           options.desc = "End of line";         }
      { action = "zl";                           key = "<C-l>";      mode = [ "n" "v" ]; options.desc = "Scroll right single"; }
      { action = "zL";                           key = "<C-k>";      mode = [ "n" "v" ]; options.desc = "Scroll right";        }
      { action = "zh";                           key = "<C-h>";      mode = [ "n" "v" ]; options.desc = "Scroll left single";  }
      { action = "zH";                           key = "<C-j>";      mode = [ "n" "v" ]; options.desc = "Scroll left";         }
      { action = luasnip "1";                    key = "<C-n>";      mode = [ "i" "s" ]; options.desc = "Next choice";         }
      { action = luasnip "-1";                   key = "<C-m>";      mode = [ "i" "s" ]; options.desc = "Prev choice";         }
      # Git
      { action = cmd "Gitsigns reset_hunk";      key = "<C-g>r";     mode = [ "n" "v" ]; options.desc = "Reset hunk";          }
      { action = cmd "Gitsigns stage_hunk";      key = "<C-g>s";     mode = [ "n" "v" ]; options.desc = "Stage hunk";          }
      { action = cmd "Gitsigns stage_buffer";    key = "<C-g>S";     mode = "n";         options.desc = "Stage buffer";        }
      { action = cmd "Gitsigns undo_stage_hunk"; key = "<C-g>u";     mode = "n";         options.desc = "Undo stage";          }
      { action = cmd "Gitsigns reset_buffer";    key = "<C-g>R";     mode = "n";         options.desc = "Reset buffer";        }
      { action = cmd "Gitsigns preview_hunk";    key = "<C-g>p";     mode = "n";         options.desc = "Preview hunk";        }
      { action = cmd "Gitsigns blame_line";      key = "<C-g>b";     mode = "n";         options.desc = "Blame line";          }
      { action = cmd "Gitsigns diffthis";        key = "<C-g>d";     mode = "n";         options.desc = "Diff";                }
      { action = cmd "Gitsigns toggle_deleted";  key = "<C-g>D";     mode = "n";         options.desc = "Toggle deleted";      }
      { action = gitlinker.line_normal;          key = "<C-g>l";     mode = "n";         options.desc = "Copy line url";       }
      { action = gitlinker.line_visual;          key = "<C-g>l";     mode = "v";         options.desc = "Copy line url";       }
      { action = gitlinker.homepage;             key = "<C-g>h";     mode = "n";         options.desc = "Copy homepage";       }
      { action = cmd "LazyGit";                  key = "<C-g>g";     mode = "n";         options.desc = "Open lazygit";        }
      # Leader
      { action = cmd "Neotree toggle";           key = "<leader>e";  mode = "n";         options.desc = "Toggle NeoTree";      }
      { action = cmd "noh";                      key = "<leader>u";  mode = "n";         options.desc = "Clear highlight";     }
      { action = cmd "w";                        key = "<leader>w";  mode = "n";         options.desc = "Save";                }
      { action = toggle "vim.o.relativenumber";  key = "<leader>n";  mode = "n";         options.desc = "Toggle relative";     }
      { action = "<cmd>EasyAlign";               key = "<leader>a";  mode = "n";         options.desc = "Align";               }
      { action = cmd "Telescope";                key = "<leader>tt"; mode = "n";         options.desc = "All";                 }
    ] ++ map (x: {
      action = cmd "Telescope ${x.cmd}"; key = "<leader>t${x.key}"; mode = "n"; options.desc = x.name;
    }) telescope_opts;

    colorscheme = "tender";

    plugins = {
      which-key = {
        enable = true;
        settings = {
          icons.mappings = false;
          spec = [
            { __unkeyed = "<C-g>"; group = "Git"; mode = [ "n" "v" ]; }
            {
              __unkeyed = [
                { __unkeyed = "<leader>";  group = "Leader";    }
                { __unkeyed = "<leader>t"; group = "Telescope"; }
                { __unkeyed = "<leader>b"; group = "Per buffer"; }
              ];
              mode = [ "n" "v" ];
            }
          ];
        };
      };
      lualine.enable = true;
      lsp = {
        enable = true;
        servers = {
          bashls.enable = true;
          cssls.enable = true;
          eslint.enable = true;
          gopls.enable = true;
          html.enable = true;
          jsonls = {
            enable = true;
            settings.schemas = [
              {
                fileMatch = [ "package.json" ];
                url = "https://json.schemastore.org/package.json";
              }
              {
                fileMatch = [ "tsconfig*.json" ];
                url = "https://json.schemastore.org/tsconfig.json";
              }
              {
                fileMatch = [ 
                  ".prettierrc"
                  ".prettierrc.json"
                  "prettier.config.json"
                ];
                url = "https://json.schemastore.org/prettierrc.json";
              }
              {
                fileMatch = [ ".eslintrc" ".eslintrc.json" ];
                url = "https://json.schemastore.org/eslintrc.json";
              }
              {
                fileMatch = [ ".babelrc" ".babelrc.json" "babel.config.json" ];
                url = "https://json.schemastore.org/babelrc.json";
              }
              {
                fileMatch = [ "lerna.json" ];
                url = "https://json.schemastore.org/lerna.json";
              }
              {
                fileMatch = [ "now.json" "vercel.json" ];
                url = "https://json.schemastore.org/now.json";
              }
              {
                fileMatch = [
                  ".stylelintrc"
                  ".stylelintrc.json"
                  "stylelint.config.json"
                ];
                url = "http://json.schemastore.org/stylelintrc.json";
              }
            ];
          };
          nixd.enable = true;
          ts-ls.enable = true;
        };
      };
      codeium-nvim.enable = true;
      cmp = {
        enable = true;
        settings = {
          preselect = "cmp.PreselectMode.None";
          sources = let
            zsh_filter = ''
              function()
                if vim.bo.filetype == "zsh" then
                  return true
                else
                  return false
                end
              end
            '';
            doc_sym = "nvim_lsp_document_symbol";
          in [
            { name = "calc";         priority = 4; group_index = 1; }
            { name = "luasnip";      priority = 4; group_index = 1; }
            # { name = "codeium";      priority = 3; group_index = 1; }
            { name = "nvim_lsp";     priority = 2; group_index = 1; }
            { name = "zsh";          priority = 2; group_index = 1; entry_filter = zsh_filter; }
            { name = "fuzzy_path";   priority = 1; group_index = 1; }
            { name = doc_sym;        priority = 2; group_index = 2; }
            { name = "treesitter";   priority = 2; group_index = 2; }
            { name = "fuzzy_buffer"; priority = 1; group_index = 2; }
          ];
          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-d>"     = "cmp.mapping.scroll_docs(-4)";
            "<C-e>"     = "cmp.mapping.close()";
            "<C-f>"     = "cmp.mapping.scroll_docs(4)";
            "<CR>"      = ''
              cmp.mapping(function(fallback)
                if cmp.visible() then
                  if require('luasnip').expandable() then
                    require('luasnip').expand()
                  else
                    cmp.confirm({select = true})
                  end
                else
                  fallback()
                end
              end)
            '';
            "<Tab>" = ''
              cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_next_item()
                elseif require('luasnip').locally_jumpable(1) then
                  require('luasnip').jump(1)
                else
                  fallback()
                end
              end, { "i", "s" })
            '';
            "<S-Tab>" = ''
              cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_prev_item()
                elseif require('luasnip').locally_jumpable(-1) then
                  require('luasnip').jump(-1)
                else
                  fallback()
                end
              end, { "i", "s" })
            '';
            "<C-Esc>" = "cmp.mapping(function(fallback) if cmp.visible() then cmp.abort() else fallback() end end)";
          };
        };
      };
      luasnip = {
        enable = true;
        fromVscode = [{}];
      };
      friendly-snippets.enable = true;
      mini = {
        enable = true;
        modules = {
          ai.enable = true;
          icons.enable = true;
          pairs = {
            modes = {
              insert = true;
              command = true;
              terminal = false;
            };
            skip_next = ''[=[[%w%%%'%[%"%.%`%$]]=]'';
            skip_ts = ''{ "string" }'';
            skip_unbalanced = true;
            markdown = true;
          };
          surround.enable = true;
        };
        mockDevIcons = true;
      };
      nvim-colorizer.enable = true;
      neo-tree.enable = true;
      treesitter = {
        enable = true;
        folding = true;
        nixvimInjections = true;
        grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          bash
          css
          diff
          go
          html
          hyprlang
          javascript
          jsdoc
          json
          jsonc
          lua
          luadoc
          luap
          markdown
          markdown_inline
          nix
          query
          regex
          scss
          toml
          typescript
          vim
          xml
          yaml
        ];
        settings = {
          highlight.enable = true;
          indent.enable = true;
        };
      };
      treesitter-context.enable = true;
      treesitter-refactor.enable = true;
      treesitter-textobjects.enable = true;
      ts-autotag.enable = true;
      ts-comments.enable = true;
      git-conflict.enable = true;
      gitsigns.enable = true;
      gitlinker.enable = true;
      lazygit = {
        enable = true;
        settings = {
          floating_window_border_chars = [ "" "" "" "" "" "" "" "" ];
        };
      };
      telescope = {
        enable = true;
        extensions = {
          fzf-native.enable = true;
        };
      };
    };
    extraPlugins = with pkgs.vimPlugins; [
      flatten-nvim
      telescope-zoxide
      tender-vim
      vim-easy-align
      lsp_signature-nvim
    ];

    autoCmd = [
      {
        event = [
          "BufNewFile"
          "BufRead"
        ];
        pattern = "**/hypr/**/*.conf";
        command = "set commentstring='# %s'";
      }
      {
        event = [
          "BufNewFile"
          "BufRead"
        ];
        pattern = "*.nix";
        callback = { __raw = ''
          function()
            MiniPairs.map_buf(vim.fn.bufnr('%'), 'i', '=', {
              action = 'open', pair = '=;', register = { cr = false }
            })
            MiniPairs.map_buf(vim.fn.bufnr('%'), 'i', ';', {
              action = 'close', pair = '=;', register = { cr = false }
            })
            MiniPairs.unmap_buf(vim.fn.bufnr('%'), 'i', "'", "\'\'")
            MiniPairs.map_buf(vim.fn.bufnr('%'), 'i', "\'\'", {
              action = 'closeopen', pair = "\'\'\'\'"
            })

            vim.keymap.set('i', '<C-e>', 'enable = true;', { buffer = vim.fn.bufnr('%') })
            vim.keymap.set('i', '<M-C-E>', ' = {<cr>enable = true;<cr><Esc><<a};<Esc>O', { buffer = vim.fn.bufnr('%') })
            vim.keymap.set('n', '<leader>be', 'aenable = true;<Esc>', { buffer = vim.fn.bufnr('%'), desc = "={enable = true;};" })
            vim.keymap.set('n', '<leader>bE', 'a = {<cr>enable = true;<cr><Esc><<a};<Esc>k$', { buffer = vim.fn.bufnr('%'), desc = "enable = true;" })
          end
        ''; };
      }
    ];

    extraConfigLuaPre = ''
      vim.g.mapleader = ' '
    '';
    extraConfigLua = ''
      require("flatten").setup()
      require("lsp_signature").setup({
        fix_pos = true,
      })

      vim.filetype.add({
        pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
      })
    '';
    extraConfigLuaPost = ''
      require('telescope').load_extension('zoxide')
      vim.keymap.del('n', '<leader>gy')
    '';
    extraConfigVim = ''
      source ${pkgs.vimPlugins.vim-easy-align}/autoload/easy_align.vim
      source ${pkgs.vimPlugins.vim-easy-align}/plugin/easy_align.vim

      set tabstop=2
      set shiftwidth=2
      set expandtab
      set nowrap
      set foldlevel=99
      set number relativenumber
      set signcolumn=yes

      hi NormalFloat guibg=#1D1D1D
      hi Pmenu guifg=#EEEEEE guibg=#1D1D1D
      hi Statement gui=italic cterm=italic
      hi @property.jsonc guifg=#73CEF4 ctermfg=81

      set splitbelow
      set splitright

      if exists('g:neovide')
        set guifont=Maple Mono:h11
        let g:neovide_cursor_vfx_mode = "ripple"
        let g:neovide_padding_top = 1
        let g:neovide_padding_right = 1
        let g:neovide_padding_bottom = 1
        let g:neovide_padding_left = 1
      endif
    '';
  };
}

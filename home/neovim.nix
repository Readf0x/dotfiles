{ pkgs, ... }:

{
  home.packages = [ pkgs.fd ];
  home.sessionVariables = { EDITOR = "nvim"; };
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
      toggle = str: { __raw = "function() ${str} = not ${str} end"; };
      cmd = str: "<cmd>${str}<CR>";
      gitlinker = {
        line_normal = cmd "lua vim.fn.setreg('', require('gitlinker').get_buf_range_url('n'))";
        line_visual = cmd "lua vim.fn.setreg('', require('gitlinker').get_buf_range_url('v'))";
        homepage =    cmd "lua vim.fn.setreg('', require('gitlinker').get_repo_url())";
      };
      telescope_opts = [
        { cmd = "buffers";     key = "b"; name = "Buffers";     }
        { cmd = "fd";          key = "f"; name = "Files";       }
        { cmd = "live_grep";   key = "g"; name = "Search";      }
        { cmd = "grep_string"; key = "s"; name = "Search word"; }
      ];
    in [
      # Remaps
      { action = "cc";                           key = "C";          mode = "n";         options.desc = "Change line";         }
      { action = "<End>";                        key = "<CR>";                           options.desc = "End of line";         }
      { action = "zl";                           key = "<C-l>";      mode = [ "n" "v" ]; options.desc = "Scroll right single"; }
      { action = "zL";                           key = "<C-k>";      mode = [ "n" "v" ]; options.desc = "Scroll right";        }
      { action = "zh";                           key = "<C-h>";      mode = [ "n" "v" ]; options.desc = "Scroll left single";  }
      { action = "zH";                           key = "<C-j>";      mode = [ "n" "v" ]; options.desc = "Scroll left";         }
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
                { __unkeyed = "<Space>"; group = "Leader"; }
                { __unkeyed = "<Space>t"; group = "Telescope"; }
              ];
              mode = [ "n" "v" ];
            }
          ];
        };
      };
      lualine = {
        enable = true;
      };
      # bufferline = { enable = true; };
      lsp = {
        enable = true;
        servers = {
          nixd.enable = true;
          gopls.enable = true;
          ts-ls.enable = true;
        };
      };
      codeium-nvim.enable = true;
      cmp = {
        enable = true;
        settings = {
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
            { name = "codeium";      priority = 3; group_index = 1; }
            { name = "nvim_lsp";     priority = 2; group_index = 1; }
            { name = "luasnip";      priority = 2; group_index = 1; }
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
            "<CR>"      = "cmp.mapping.confirm({ select = true })";
            "<S-Tab>"   = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<Tab>"     = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
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
          ai = {
            enable = true;
          };
          surround = {
            enable = true;
          };
        };
      };
      nvim-colorizer = {
        enable = true;
      };
      neo-tree = {
        enable = true;
      };
      treesitter = {
        enable = true;
        folding = true;
        nixvimInjections = true;
        grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          bash
          css
          diff
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
      };
      git-conflict = {
        enable = true;
      };
      gitsigns = {
        enable = true;
      };
      gitlinker = {
        enable = true;
      };
      lazygit = {
        enable = true;
      };
      telescope = {
        enable = true;
      };
    };
    extraPlugins = with pkgs.vimPlugins; [
      tender-vim
      flatten-nvim
      vim-easy-align
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
          end
        ''; };
      }
    ];

    extraConfigLuaPre = ''
      vim.g.mapleader = ' '
    '';
    extraConfigLua = ''
      require("flatten").setup()

      vim.filetype.add({
        pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
      })
    '';
    extraConfigLuaPost = ''
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

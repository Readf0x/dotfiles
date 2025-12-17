{ pkgs, lib, inputs, self, config, ... }: let
  colors = config.lib.stylix.colors;
  color = hx: "#${colors."base${hx}"}";
  mkLuaInline = lib.generators.mkLuaInline;
  system = pkgs.stdenv.hostPlatform.system;
in {
  programs.nvf = {
    enable = true;
    settings.vim = {
      viAlias = true;
      vimAlias = true;
      
      globals.mapleader = " ";
      
      lineNumberMode = "relNumber";
      
      clipboard = {
        enable = true;
        providers.wl-copy.enable = true;
        registers = "unnamedplus";
      };
      
      options = {
        tabstop = 2;
        shiftwidth = 2;
        wrap = false;
        signcolumn = "yes";
        splitbelow = true;
        splitright = true;
      };
      
      # Theme
      theme = {
        enable = true;
        name = "everforest";
        style = "medium";
      };

      statusline.lualine = {
        enable = true;
        componentSeparator = { left = "┃"; right = "┃"; };
        sectionSeparator = { left = ""; right = ""; };
        ignoreFocus = [ "neo-tree" "nvim-tree" "mini-files" ];
        globalStatus = false;
        setupOpts.options.theme = {
          normal = {
            a = { bg = color "08"; fg = color "01"; };
            b = { bg = color "02"; fg = color "05"; };
            c = { bg = color "01"; fg = color "03"; };
          };
          insert = {
            a = { bg = color "0B"; fg = color "01"; };
            b = { bg = color "02"; fg = color "05"; };
            c = { bg = color "01"; fg = color "03"; };
          };
          visual = {
            a = { bg = color "0E"; fg = color "01"; };
            b = { bg = color "02"; fg = color "05"; };
            c = { bg = color "01"; fg = color "03"; };
          };
          command = {
            a = { bg = color "09"; fg = color "01"; };
            b = { bg = color "02"; fg = color "05"; };
            c = { bg = color "01"; fg = color "03"; };
          };
        };
        activeSection = {
          a = [ ''{ "mode" }'' ];
          b = [ ''{ "branch", icon = '', }'' ''{ "diff" }'' ];
          c = [ ''{ "filename" }'' ];
          x = [ ''{ "encoding" }'' ''{ "filetype", colored = true, icon = { align = 'left' } }'' ];
          y = [ ''{ "progress" }'' ];
          z = [ ''{ "location" }'' ];
        };
        inactiveSection = {
          a = [];
          b = [];
          c = [ ''{ "filename" }'' ];
          x = [ ''{ "location" }'' ];
          y = [];
          z = [];
        };
      };
      
      # LSP
      lsp = {
        enable = true;
        formatOnSave = false;
      };
      
      # Treesitter
      treesitter = {
        enable = true;
        fold = true;
        grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          bash
          css
          diff
          go
          html
          hyprlang
          java
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
          qmljs
          query
          regex
          scss
          toml
          typescript
          vim
          xml
          yaml
          ocaml
          templ
          odin
          inputs.tree-sitter-tet.packages.${system}.default
          self.packages.${system}.tree-sitter-umka
        ];
      };
      
      # Telescope
      telescope.enable = true;
      
      # Git
      git = {
        enable = true;
        gitsigns.enable = true;
      };
      
      # Filetree
      filetree.neo-tree.enable = true;
      
      # Languages
      languages = {
        enableTreesitter = true;
        enableFormat = false;
        
        bash = {
          enable = true;
          lsp.enable = true;
        };
        
        go = {
          enable = true;
          lsp.enable = true;
        };
        
        html = {
          enable = true;
          lsp = {
            enable = true;
            servers = [ "emmet-ls" "superhtml" ];
          };
        };
        
        nix = {
          enable = true;
          lsp = {
            enable = true;
            servers = [ "nil" ];
          };
        };
        
        markdown.enable = true;
        
        # Additional LSPs from nixvim
        ts = {
          enable = true;
          lsp.enable = false;
        };

        odin = {
          enable = true;
          lsp.enable = true;
        };
      };
      
      # Autocomplete
      autocomplete.nvim-cmp = {
        enable = true;
        sources = {
          nvim-lsp = "[LSP]";
          luasnip = "[Snip]";
          buffer = "[Buffer]";
          path = "[Path]";
        };
      };
      
      # Snippets - note: nvf might not have built-in luasnip support like nixvim
      # You may need to add this as an extra plugin
      
      # Keymaps
      keymaps = [
        # Remaps
        { key = "C";     mode = "n";       action = "cc";    desc = "Change line";         }
        { key = "<CR>";  mode = "n";       action = "<End>"; desc = "End of line";         }
        { key = "<C-l>"; mode = ["n" "v"]; action = "zl";    desc = "Scroll right single"; }
        { key = "<C-k>"; mode = ["n" "v"]; action = "zL";    desc = "Scroll right";        }
        { key = "<C-h>"; mode = ["n" "v"]; action = "zh";    desc = "Scroll left single";  }
        { key = "<C-j>"; mode = ["n" "v"]; action = "zH";    desc = "Scroll left";         }
        
        # Git mappings
        { key = "<C-g>r"; mode = ["n" "v"]; action = "<cmd>Gitsigns reset_hunk<CR>";      desc = "Reset hunk";     }
        { key = "<C-g>s"; mode = ["n" "v"]; action = "<cmd>Gitsigns stage_hunk<CR>";      desc = "Stage hunk";     }
        { key = "<C-g>S"; mode = "n";       action = "<cmd>Gitsigns stage_buffer<CR>";    desc = "Stage buffer";   }
        { key = "<C-g>u"; mode = "n";       action = "<cmd>Gitsigns undo_stage_hunk<CR>"; desc = "Undo stage";     }
        { key = "<C-g>R"; mode = "n";       action = "<cmd>Gitsigns reset_buffer<CR>";    desc = "Reset buffer";   }
        { key = "<C-g>p"; mode = "n";       action = "<cmd>Gitsigns preview_hunk<CR>";    desc = "Preview hunk";   }
        { key = "<C-g>b"; mode = "n";       action = "<cmd>Gitsigns blame_line<CR>";      desc = "Blame line";     }
        { key = "<C-g>d"; mode = "n";       action = "<cmd>Gitsigns diffthis<CR>";        desc = "Diff";           }
        { key = "<C-g>D"; mode = "n";       action = "<cmd>Gitsigns toggle_deleted<CR>";  desc = "Toggle deleted"; }
        
        # Leader mappings
        { key = "<leader>e";  mode = "n";       action = "<cmd>Neotree toggle<CR>";        desc = "Toggle NeoTree";                                        }
        { key = "<leader>u";  mode = "n";       action = "<cmd>noh<CR>";                   desc = "Clear highlight";                                       }
        { key = "<leader>s";  mode = "n";       action = "<cmd>w<CR>";                     desc = "Save";                                                  }
        { key = "<leader>A";  mode = ["n" "v"]; action = ":EasyAlign ";                    desc = "Align";                                                 }
        { key = "<leader>V";  mode = "n";       action = "vi{:EasyAlign<CR>* ";            desc = "Align struct";                                          }
        { key = "<leader>tt"; mode = "n";       action = "<cmd>Telescope<CR>";             desc = "All";                                                   }
        { key = "<leader>tb"; mode = "n";       action = "<cmd>Telescope buffers<CR>";     desc = "Buffers";                                               }
        { key = "<leader>tf"; mode = "n";       action = "<cmd>Telescope fd<CR>";          desc = "Files";                                                 }
        { key = "<leader>tg"; mode = "n";       action = "<cmd>Telescope live_grep<CR>";   desc = "Search";                                                }
        { key = "<leader>ts"; mode = "n";       action = "<cmd>Telescope grep_string<CR>"; desc = "Search word";                                           }

        { key = "gd"; mode = "n"; lua = true; action = "function() vim.lsp.buf.definition() end"; desc = "Definition"; }
      ];

      ui = {
        colorizer.enable = true;
      };

      utility = {
        ccc.enable = true;
      };

      snippets = {
        luasnip = {
          enable = true;
          loaders = ''
            require("luasnip.loaders.from_vscode").lazy_load()
            require("luasnip.loaders.from_lua").load({paths = "${./snippets}"})
          '';
        };
      };

      mini = {
        ai.enable = true;
        icons.enable = true;
        pairs = {
          enable = true;
          setupOpts = {
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
        };
        surround.enable = true;
      };
      
      # Extra plugins
      extraPlugins = {
        flatten-nvim = {
          package = pkgs.vimPlugins.flatten-nvim;
          setup = "require('flatten').setup()";
        };
        
        vim-easy-align = {
          package = pkgs.vimPlugins.vim-easy-align;
        };
        
        zoxide-vim = {
          package = pkgs.vimPlugins.zoxide-vim;
        };
        
        telescope-zoxide = {
          package = pkgs.vimPlugins.telescope-zoxide;
          setup = "require('telescope').load_extension('zoxide')";
        };
        
        luasnip = {
          package = pkgs.vimPlugins.luasnip;
          setup = ''
            local luasnip = require('luasnip')
            require("luasnip.loaders.from_vscode").lazy_load()
            require("luasnip.loaders.from_lua").load({paths = "${./snippets}"})
          '';
        };
        
        friendly-snippets = {
          package = pkgs.vimPlugins.friendly-snippets;
        };
        
        inc-rename = {
          package = pkgs.vimPlugins.inc-rename-nvim;
          setup = "require('inc_rename').setup()";
        };
        
        ts-autotag = {
          package = pkgs.vimPlugins.nvim-ts-autotag;
          setup = "require('nvim-ts-autotag').setup()";
        };
        
        ts-comments = {
          package = pkgs.vimPlugins.ts-comments-nvim;
          setup = "require('ts-comments').setup()";
        };
        
        git-conflict = {
          package = pkgs.vimPlugins.git-conflict-nvim;
          setup = "require('git-conflict').setup()";
        };
        
        gitlinker = {
          package = pkgs.vimPlugins.gitlinker-nvim;
          setup = "require('gitlinker').setup()";
        };
        
        lazygit = {
          package = pkgs.vimPlugins.lazygit-nvim;
        };
        
        render-markdown = {
          package = pkgs.vimPlugins.render-markdown-nvim;
          setup = "require('render-markdown').setup()";
        };
        
        image = {
          package = pkgs.vimPlugins.image-nvim;
          setup = "require('image').setup()";
        };
        
        undotree = {
          package = pkgs.vimPlugins.undotree;
        };
        
        dap-virtual-text = {
          package = pkgs.vimPlugins.nvim-dap-virtual-text;
          setup = "require('nvim-dap-virtual-text').setup()";
        };
        
        lsp-signature = {
          package = pkgs.vimPlugins.lsp_signature-nvim;
          setup = ''
            require("lsp_signature").setup({
              fix_pos = true,
              handler_opts = { border = "none" },
              hint_prefix = "? "
            })
          '';
        };
        
        treesitter-context = {
          package = pkgs.vimPlugins.nvim-treesitter-context;
          setup = "require('treesitter-context').setup()";
        };
      };
      
      # Autocmds
      autocmds = [
        {
          enable = true;
          event = [ "BufNewFile" "BufRead" ];
          pattern = [ "**/hypr/**/*.conf" ];
          command = "set commentstring='# %s'";
        }
        
        {
          enable = true;
          event = [ "TextChanged" "TextChangedI" "ModeChanged" ];
          pattern = [ "*.md" ];
          callback = mkLuaInline ''
            function()
              if started == nil then
                started = os.time()
              end
              if os.time() > started then
                vim.cmd("silent write")
                started = os.time()
              end
            end
          '';
        }
        
        {
          enable = true;
          event = [ "BufNewFile" "BufRead" ];
          pattern = [ "*.nix" ];
          callback = mkLuaInline ''
            function()
              local MiniPairs = require('mini.pairs')
              MiniPairs.map_buf(vim.fn.bufnr('%'), 'i', '=', { action = 'open', pair = '=;', register = { cr = false } })
              MiniPairs.map_buf(vim.fn.bufnr('%'), 'i', ';', { action = 'close', pair = '=;', register = { cr = false } })
              
              vim.keymap.set("i", "<C-e>", function() require("luasnip").snip_expand(require("luasnip").get_snippets().nix[1]) end, { buffer = vim.fn.bufnr("%") })
              vim.keymap.set("i", "<M-C-e>", function() require("luasnip").snip_expand(require("luasnip").get_snippets().nix[3]) end, { buffer = vim.fn.bufnr("%") })
              vim.keymap.set("n", "<leader>bh", "<cmd>split|:term nh home switch .<CR>", { buffer = vim.fn.bufnr("%"), desc = "Build Home-Manager" })
              vim.keymap.set("n", "<leader>bt", "<cmd>split|:term nh os test .<CR>", { buffer = vim.fn.bufnr("%"), desc = "System rebuild test" })
              vim.keymap.set("n", "<leader>br", "<cmd>split|:term nh os switch .<CR>", { buffer = vim.fn.bufnr("%"), desc = "System rebuild switch" })
              vim.keymap.set("n", "<C-f>", "f v3whc.<Esc>jddk", { buffer = vim.fn.bufnr("%"), desc = "Format one line attr set" })
              vim.keymap.set("n", "<M-C-f>", "<cmd>s/\\.\\(.*;\\)/ = { \\1 };<CR>f{lr<CR>$F r<CR><cmd>noh<CR>", { buffer = vim.fn.bufnr("%"), desc = "Format one line attr set" })
            end
          '';
        }
        
        {
          enable = true;
          event = [ "BufNewFile" "BufRead" ];
          pattern = [ "*.odin" ];
          callback = mkLuaInline ''
            function()
              vim.b.CC = "odin build ."
            end
          '';
        }
        
        {
          enable = true;
          event = [ "BufNewFile" "BufRead" ];
          pattern = [ "*.go" ];
          callback = mkLuaInline ''
            function()
              vim.b.CC = "go build ."
            end
          '';
        }
        
        {
          enable = true;
          event = [ "BufNewFile" "BufRead" ];
          pattern = [ "*.tet" ];
          command = "set filetype=tet";
        }
        
        {
          enable = true;
          event = [ "BufNewFile" "BufRead" ];
          pattern = [ "*.tet" ];
          callback = mkLuaInline ''
            function()
              vim.keymap.set("i", "<C-e>", function() require("luasnip").snip_expand(require("luasnip").get_snippets().tet[1]) end, { buffer = vim.fn.bufnr("%") })
              vim.keymap.set("n", "<leader>bb", "<cmd>!te "..vim.fn.expand("%p").."<CR>", { buffer = vim.fn.bufnr("%"), desc = "Process file" })
            end
          '';
        }
        
        {
          enable = true;
          event = [ "BufNewFile" "BufRead" ];
          pattern = [ "*.html.tet" ];
          callback = mkLuaInline ''
            function()
              require"luasnip".filetype_extend("tet", { "html" })
            end
          '';
        }
        
        {
          enable = true;
          event = [ "BufNewFile" "BufRead" ];
          pattern = [ "*.css.tet" ];
          command = "set filetype=css";
        }
        
        {
          enable = true;
          event = [ "TermOpen" ];
          pattern = [ "*" ];
          command = "startinsert";
        }
      ];
      
      # Lua configuration
      luaConfigRC = {
        compile-command = ''
          vim.b.CC = "echo No compile command set"
          vim.api.nvim_create_user_command('CC', function(opts)
            vim.g.CC = opts.args
          end, { desc = 'Set compile command', nargs = "+" })
        '';
        
        filetypes = ''
          vim.filetype.add({
            pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
            extension = { um = "umka" },
          })
        '';
        
        gitlinker-mappings = ''
          vim.keymap.set("n", "<C-g>l", function()
            vim.fn.setreg(''', require('gitlinker').get_buf_range_url('n'))
          end, { desc = "Copy line url" })
          
          vim.keymap.set("v", "<C-g>l", function()
            vim.fn.setreg(''', require('gitlinker').get_buf_range_url('v'))
          end, { desc = "Copy line url" })
          
          vim.keymap.set("n", "<C-g>h", function()
            vim.fn.setreg(''', require('gitlinker').get_repo_url())
          end, { desc = "Copy homepage" })
          
          vim.keymap.set("n", "<C-g>g", "<cmd>LazyGit<CR>", { desc = "Open lazygit" })
        '';
        
        custom-keymaps = ''
          vim.keymap.set("n", "<leader>n", function()
            vim.o.relativenumber = not vim.o.relativenumber
          end, { desc = "Toggle relative" })
          
          vim.keymap.set("n", "<leader>d", function()
            vim.diagnostic.open_float()
          end, { desc = "Diagnostic" })
          
          vim.keymap.set("n", "<leader>p", "<cmd>CccPick<CR>", { desc = "Color Picker" })
          
          vim.keymap.set("n", "<leader>c", function()
            vim.cmd(':split|:term '..(vim.g.CC or vim.b.CC))
          end, { desc = "Compile" })
          
          vim.keymap.set("n", "<leader>C", "<cmd>TSContextToggle<CR>", { desc = "Toggle Context" })
          
          vim.keymap.set("n", "<leader>r", ":IncRename ", { desc = "Rename" })
          
          -- Luasnip choice navigation
          vim.keymap.set({"i", "s"}, "<C-n>", function()
            if require('luasnip').choice_active() then
              require('luasnip').change_choice(1)
            end
          end, { desc = "Next choice" })
          
          vim.keymap.set({"i", "s"}, "<C-m>", function()
            if require('luasnip').choice_active() then
              require('luasnip').change_choice(-1)
            end
          end, { desc = "Prev choice" })
        '';
        
        helpers = ''
          function get_current_lang()
            local curline = vim.fn.line(".")
            return vim.treesitter.get_parser():language_for_range({curline, 0, curline, 0}):lang()
          end
        '';
        
        cmp-config = ''
          local cmp = require('cmp')
          cmp.setup({
            mapping = {
              ["<CR>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                  if require('luasnip').expandable() then
                    require('luasnip').expand()
                  else
                    cmp.confirm({select = true})
                  end
                else
                  fallback()
                end
              end),
              ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_next_item()
                elseif require('luasnip').locally_jumpable(1) then
                  require('luasnip').jump(1)
                else
                  fallback()
                end
              end, { "i", "s" }),
              ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_prev_item()
                elseif require('luasnip').locally_jumpable(-1) then
                  require('luasnip').jump(-1)
                else
                  fallback()
                end
              end, { "i", "s" }),
            },
          })
        '';
      };
      
      # Highlight groups
      highlight = {
        TSVariable                     = { fg = color "0D"; };
        TSMethod                       = { fg = color "0B"; };
        TSString                       = { fg = color "09"; };
        TSKeyword                      = { fg = color "0F"; };
        TSFunction                     = { fg = color "0B"; };
        TSComment                      = { fg = color "04"; };
        LineNr                         = { fg = color "03"; };
        NormalFloat                    = { bg = color "01"; };
        TSTag                          = { fg = color "05"; };
        "@tag.html"                    = { fg = color "05"; };
        "@tag.templ"                   = { fg = color "08"; };
        htmlTag                        = { fg = color "05"; };
        htmlEndTag                     = { fg = color "05"; };
        "@punctuation.delimiter.jsdoc" = { fg = color "05"; };
        "@string.special.templ"        = { fg = color "05"; };
        "@property.jsonc"              = { fg = color "0D"; };
        "@lsp.type.parameter.nix"      = { fg = color "05";};
        Pmenu                          = { fg = color "05"; bg = color "01";   };
        Statement                      = { italic = true; };
      };
    };
  };
}

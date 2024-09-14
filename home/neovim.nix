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

    keymaps = [
      {
        action = "<cmd>Neotree toggle<CR>";
        key = "<Space>e";
        mode = "n";
      }
    ];

    colorscheme = "tender";

    plugins = {
      lualine = {
        enable = true;
      };
      bufferline = {
        enable = true;
      };
      lsp = {
        enable = true;
        servers = {
          nixd.enable = true;
          gopls.enable = true;
        };
      };
      codeium-nvim.enable = true;
      cmp = {
        enable = true;
        settings = {
          sources = [
            { name = "calc"; priority = 4; group_index = 1; }
            { name = "zsh"; priority = 4; group_index = 1; }
            { name = "codeium"; priority = 3; group_index = 1; }
            { name = "nvim_lsp"; priority = 2; group_index = 1; }
            { name = "nvim_lsp_document_symbol"; priority = 1; group_index = 1; }
            { name = "fuzzy_path"; priority = 1; group_index = 1; }
            { name = "treesitter"; priority = 2; group_index = 2; }
            { name = "fuzzy_buffer"; priority = 1; group_index = 2; }
          ];
          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            "<C-e>" = "cmp.mapping.close()";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          };
        };
      };
      nvim-snippets = {
        enable = true;
        settings.friendly_snippets = true;
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
      which-key = {
        enable = true;
        settings.icons.mappings = false;
      };
    };
    extraPlugins = with pkgs.vimPlugins; [
      tender-vim
      flatten-nvim
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
          end
        ''; };
      }
    ];

    extraConfigLua = ''
      vim.o.tabstop = 2
      vim.o.shiftwidth = 2
      vim.o.expandtab = true
      vim.o.wrap = false
      vim.o.foldlevel = 99
      vim.o.relativenumber = true

      vim.g.mapleader = " "

      vim.opt.splitright = true
      vim.opt.splitbelow = true

      if vim.g.neovide then
        vim.o.guifont = "Maple Mono:h11"
        vim.g.neovide_cursor_vfx_mode = "ripple"
        vim.g.neovide_padding_top = 1
        vim.g.neovide_padding_right = 1
        vim.g.neovide_padding_bottom = 1
        vim.g.neovide_padding_left = 1
      end

      vim.filetype.add({
        pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
      })
    '';
  };
}

{ config, pkgs, ... }:

{
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
    ];

    colorscheme = "tender";

    plugins = {
      lualine = {
        enable = true;
      };
      bufferline = {
        enable = true;
      };
      #codeium-vim = {
      #  enable = true;
      #  keymaps = {
      #    accept = "<C-a>";
      #  };
      #};
      cmp = {
        enable = true;
        settings = {
          sources = [
            { name = "nvim_lsp"; }
            { name = "buffer"; }
            { name = "path"; }
          ];
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
    ];

    extraConfigLua = ''
      vim.o.tabstop = 2
      vim.o.shiftwidth = 2
      vim.o.expandtab = true
      vim.o.smartindent = true
      vim.o.wrap = false

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

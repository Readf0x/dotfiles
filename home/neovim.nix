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
      codeium-vim = {
        enable = true;
        keymaps = {
          accept = "<C-a>";
        };
      };
      nvim-colorizer = {
        enable = true;
      };
      neo-tree = {
        enable = true;
      };
    };
    extraPlugins = with pkgs.vimPlugins; [
      tender-vim
      flatten-nvim
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
        vim.o.guifont = "FiraCode Nerd Font:h11"
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

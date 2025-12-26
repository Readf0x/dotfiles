{ pkgs, lib, config, ... }: {
  programs.genvim = {
    enable = true;
    # manageLazy = false;
    treesitter-grammars = pkgs.vimPlugins.nvim-treesitter.allGrammars ++ [ pkgs.tree-sitter-tet.default pkgs.this.tree-sitter-umka ];
    plugins = with pkgs.vimPlugins; [
      everforest
      flatten-nvim
      lsp_signature-nvim
      nvim-lspconfig
      vim-easy-align
      zoxide-vim
      everforest
      lualine-nvim
      nvim-colorizer-lua
      ccc-nvim
      which-key-nvim
      mini-nvim
      render-markdown-nvim
      image-nvim
      neo-tree-nvim
      plenary-nvim
      telescope-nvim
      telescope-fzf-native-nvim
      telescope-zoxide
      undotree
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-nvim-lsp-document-symbol
      cmp_luasnip
      luasnip
      friendly-snippets
      inc-rename-nvim
      nvim-treesitter
      nvim-treesitter-context
      nvim-ts-autotag
      ts-comments-nvim
      vim-nix
      gitsigns-nvim
      gitlinker-nvim
      lazygit-nvim
      git-conflict-nvim
      nvim-dap
      nvim-dap-view
      nvim-dap-virtual-text
      nui-nvim
    ];

    lsps = with pkgs; [
      bash-language-server
      gopls
      templ
      vscode-langservers-extracted
      htmx-lsp
      tailwindcss-language-server
      nil
      kdePackages.qtdeclarative
      ocamlPackages.ocaml-lsp
      ols
    ];
  };

  home.activation.genvim = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ ! -d ${toString config.home.homeDirectory}/.config/nvim ]; then
      ${pkgs.git}/bin/git clone https://github.com/readf0x/nvim-config ${toString config.home.homeDirectory}/.config/nvim
    fi
  '';
}

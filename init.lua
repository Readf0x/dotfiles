-- Nixvim's internal module table
-- Can be used to share code throughout init.lua
local _M = {}

-- Set up globals {{{
do
  local nixvim_globals = { }

  for k,v in pairs(nixvim_globals) do
    vim.g[k] = v
  end
end
-- }}}

-- Set up options {{{
do
  local nixvim_options = { clipboard = "unnamedplus", foldexpr = "nvim_treesitter#foldexpr()", foldmethod = "expr" }

  for k,v in pairs(nixvim_options) do
    vim.opt[k] = v
  end
end
-- }}}


vim.g.mapleader = ' '

vim.cmd([[
let $BAT_THEME = 'tender'

colorscheme tender

source /nix/store/2s8sp3djvgfz6jwkq09jjpkcd1i62yck-vimplugin-vim-easy-align-2024-04-13/autoload/easy_align.vim
source /nix/store/2s8sp3djvgfz6jwkq09jjpkcd1i62yck-vimplugin-vim-easy-align-2024-04-13/plugin/easy_align.vim

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

]])

local cmp = require('cmp')
cmp.setup({ mapping = { ["<C-Space>"] = cmp.mapping.complete(), ["<C-d>"] = cmp.mapping.scroll_docs(-4), ["<C-e>"] = cmp.mapping.close(), ["<C-f>"] = cmp.mapping.scroll_docs(4), ["<CR>"] = cmp.mapping.confirm({ select = true }), ["<S-Tab>"] = cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'}), ["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'}) }, sources = { { group_index = 1, name = "calc", priority = 4 }, { group_index = 1, name = "codeium", priority = 3 }, { group_index = 1, name = "nvim_lsp", priority = 2 }, { group_index = 1, name = "luasnip", priority = 2 }, { entry_filter = function()
  if vim.bo.filetype == "zsh" then
    return true
  else
    return false
  end
end
, group_index = 1, name = "zsh", priority = 2 }, { group_index = 1, name = "fuzzy_path", priority = 1 }, { group_index = 2, name = "nvim_lsp_document_symbol", priority = 2 }, { group_index = 2, name = "treesitter", priority = 2 }, { group_index = 2, name = "fuzzy_buffer", priority = 1 } } })


require('which-key').setup({ icons = { mappings = false }, spec = { { "<C-g>", group = "Git", mode = { "n", "v" } }, { { { "<Space>", group = "Leader" }, { "<Space>t", group = "Telescope" } }, mode = { "n", "v" } } } })

vim.opt.runtimepath:prepend(vim.fs.joinpath(vim.fn.stdpath('data'), 'site'))
require('nvim-treesitter.configs').setup({ parser_install_dir = vim.fs.joinpath(vim.fn.stdpath('data'), 'site') })

require('telescope').setup({ })

local __telescopeExtensions = { }
for i, extension in ipairs(__telescopeExtensions) do
  require('telescope').load_extension(extension)
end


require("mini.ai").setup({ enable = true })

require("mini.pairs").setup({ markdown = true, modes = { command = true, insert = true, terminal = false }, skip_next = "[=[[%w%%%'%[%\"%.%`%$]]=]", skip_ts = "{ \"string\" }", skip_unbalanced = true })

require("mini.surround").setup({ enable = true })

require('lualine').setup({ })

require('gitsigns').setup({ })

require('git-conflict').setup({ })

require('codeium').setup({ })

-- LSP {{{
do
  

  local __lspServers = { { name = "ts_ls" }, { name = "nixd" }, { name = "gopls" } }
  -- Adding lspOnAttach function to nixvim module lua table so other plugins can hook into it.
  _M.lspOnAttach = function(client, bufnr)
    

    
  end
  local __lspCapabilities = function()
    capabilities = vim.lsp.protocol.make_client_capabilities()

    capabilities = vim.tbl_deep_extend("force", capabilities, require('cmp_nvim_lsp').default_capabilities())


    return capabilities
  end

  local __setup = {
            on_attach = _M.lspOnAttach,
            capabilities = __lspCapabilities()
          }

  for i,server in ipairs(__lspServers) do
    if type(server) == "string" then
      require('lspconfig')[server].setup(__setup)
    else
      local options = server.extraOptions

      if options == nil then
        options = __setup
      else
        options = vim.tbl_extend("keep", options, __setup)
      end

      require('lspconfig')[server.name].setup(options)
    end
  end

  
end
-- }}}

require("colorizer").setup({
  filetypes = nil,
  user_default_options = nil,
  buftypes = nil,
})

require('neo-tree').setup({ document_symbols = { custom_kinds = {} } })

require("luasnip").config.setup({ })

require("luasnip.loaders.from_vscode").lazy_load({ })

require("luasnip.loaders.from_vscode").lazy_load({ })

require('gitlinker').setup({ })

-- Set up keybinds {{{
do
  local __nixvim_binds = { { action = "cc", key = "C", mode = "n", options = { desc = "Change line" } }, { action = "<End>", key = "<CR>", mode = "", options = { desc = "End of line" } }, { action = "zl", key = "<C-l>", mode = { "n", "v" }, options = { desc = "Scroll right single" } }, { action = "zL", key = "<C-k>", mode = { "n", "v" }, options = { desc = "Scroll right" } }, { action = "zh", key = "<C-h>", mode = { "n", "v" }, options = { desc = "Scroll left single" } }, { action = "zH", key = "<C-j>", mode = { "n", "v" }, options = { desc = "Scroll left" } }, { action = function() jump(1) end, key = "<C-l>", mode = { "i", "s" }, options = { desc = "Next option" } }, { action = function() jump(-1) end, key = "<C-h>", mode = { "i", "s" }, options = { desc = "Prev option" } }, { action = function() require('false').if luasnip.choice_active() then luasnip.change_choice(1) end end, key = "<C-n>", mode = { "i", "s" }, options = { desc = "Next choice" } }, { action = function() require('false').if luasnip.choice_active() then luasnip.change_choice(-1) end end, key = "<C-m>", mode = { "i", "s" }, options = { desc = "Prev choice" } }, { action = "<cmd>Gitsigns reset_hunk<CR>", key = "<C-g>r", mode = { "n", "v" }, options = { desc = "Reset hunk" } }, { action = "<cmd>Gitsigns stage_hunk<CR>", key = "<C-g>s", mode = { "n", "v" }, options = { desc = "Stage hunk" } }, { action = "<cmd>Gitsigns stage_buffer<CR>", key = "<C-g>S", mode = "n", options = { desc = "Stage buffer" } }, { action = "<cmd>Gitsigns undo_stage_hunk<CR>", key = "<C-g>u", mode = "n", options = { desc = "Undo stage" } }, { action = "<cmd>Gitsigns reset_buffer<CR>", key = "<C-g>R", mode = "n", options = { desc = "Reset buffer" } }, { action = "<cmd>Gitsigns preview_hunk<CR>", key = "<C-g>p", mode = "n", options = { desc = "Preview hunk" } }, { action = "<cmd>Gitsigns blame_line<CR>", key = "<C-g>b", mode = "n", options = { desc = "Blame line" } }, { action = "<cmd>Gitsigns diffthis<CR>", key = "<C-g>d", mode = "n", options = { desc = "Diff" } }, { action = "<cmd>Gitsigns toggle_deleted<CR>", key = "<C-g>D", mode = "n", options = { desc = "Toggle deleted" } }, { action = function() require('false').vim.fn.setreg('', require('gitlinker').get_buf_range_url('n')) end, key = "<C-g>l", mode = "n", options = { desc = "Copy line url" } }, { action = function() require('false').vim.fn.setreg('', require('gitlinker').get_buf_range_url('v')) end, key = "<C-g>l", mode = "v", options = { desc = "Copy line url" } }, { action = function() require('false').vim.fn.setreg('', require('gitlinker').get_repo_url()) end, key = "<C-g>h", mode = "n", options = { desc = "Copy homepage" } }, { action = "<cmd>LazyGit<CR>", key = "<C-g>g", mode = "n", options = { desc = "Open lazygit" } }, { action = "<cmd>Neotree toggle<CR>", key = "<leader>e", mode = "n", options = { desc = "Toggle NeoTree" } }, { action = "<cmd>noh<CR>", key = "<leader>u", mode = "n", options = { desc = "Clear highlight" } }, { action = "<cmd>w<CR>", key = "<leader>w", mode = "n", options = { desc = "Save" } }, { action = function() require('false').vim.o.relativenumber = not vim.o.relativenumber end, key = "<leader>n", mode = "n", options = { desc = "Toggle relative" } }, { action = "<cmd>Telescope<CR>", key = "<leader>tt", mode = "n", options = { desc = "All" } }, { action = "<cmd>Telescope buffers<CR>", key = "<leader>tb", mode = "n", options = { desc = "Buffers" } }, { action = "<cmd>Telescope fd<CR>", key = "<leader>tf", mode = "n", options = { desc = "Files" } }, { action = "<cmd>Telescope live_grep<CR>", key = "<leader>tg", mode = "n", options = { desc = "Search" } }, { action = "<cmd>Telescope grep_string<CR>", key = "<leader>ts", mode = "n", options = { desc = "Search word" } } }
  for i, map in ipairs(__nixvim_binds) do
    vim.keymap.set(map.mode, map.key, map.action, map.options)
  end
end
-- }}}

require("flatten").setup()

vim.filetype.add({
  pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
})

-- Set up autogroups {{
do
  local __nixvim_autogroups = { nixvim_binds_LspAttach = { clear = true } }

  for group_name, options in pairs(__nixvim_autogroups) do
    vim.api.nvim_create_augroup(group_name, options)
  end
end
-- }}
-- Set up autocommands {{
do
  local __nixvim_autocommands = { { callback = function()
  do
    local __nixvim_binds = { }
    for i, map in ipairs(__nixvim_binds) do
      vim.keymap.set(map.mode, map.key, map.action, map.options)
    end
  end
end
, desc = "Load keymaps for LspAttach", event = "LspAttach", group = "nixvim_binds_LspAttach" }, { command = "set commentstring='# %s'", event = { "BufNewFile", "BufRead" }, pattern = "**/hypr/**/*.conf" }, { callback = function()
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
, event = { "BufNewFile", "BufRead" }, pattern = "*.nix" } }

  for _, autocmd in ipairs(__nixvim_autocommands) do
    vim.api.nvim_create_autocmd(
      autocmd.event,
      {
        group     = autocmd.group,
        pattern   = autocmd.pattern,
        buffer    = autocmd.buffer,
        desc      = autocmd.desc,
        callback  = autocmd.callback,
        command   = autocmd.command,
        once      = autocmd.once,
        nested    = autocmd.nested
      }
    )
  end
end
-- }}

vim.keymap.del('n', '<leader>gy')



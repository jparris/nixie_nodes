-- Set up the leader key before initializing plugins
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

-- Bootstrap Lazy.NVIM Package Manger
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git", "--branch=stable", -- latest stable release
        lazypath
    })
end
vim.opt.rtp:prepend(lazypath)

-- Plugins
require("lazy").setup({
    { -- catppuccin theme
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        config = function() vim.cmd.colorscheme 'catppuccin-macchiato' end
    }, -- gitgutter
    {"airblade/vim-gitgutter", name = "gitgutter"}, {
        "akinsho/bufferline.nvim",
        dependencies = {'nvim-tree/nvim-web-devicons'},
        config = function() require("bufferline").setup() end
    }, -- lualine
    {
        'nvim-lualine/lualine.nvim',
        opts = {options = { component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''}, icons_enabled = true, theme = 'catppuccin-macchiato'}}
    }, -- beter-escap used for j-k escape 
    {
        "max397574/better-escape.nvim",
        config = function() require("better_escape").setup() end
    }, -- fzf
    {'junegunn/fzf.vim', dependencies = {'junegunn/fzf'}}, -- telekasten
    {
        'renerocksai/telekasten.nvim',
        dependencies = {'nvim-telekasten/calendar-vim', 'nvim-telescope/telescope.nvim'},
        config = function()
            require("telekasten").setup({home = vim.fn.expand("~/notes")})
        end
    },
    {'nvim-telescope/telescope.nvim', dependencies = {'nvim-lua/plenary.nvim'}},
    {'mrjones2014/smart-splits.nvim'}
})

--[[
{
'nvim-treesitter/nvim-treesitter',
build = ':TSUpdate',
},

-- Tree-sitter configuration
require'nvim-treesitter.configs'.setup {
-- If TS highlights are not enabled at all, or disabled via ``disable`` prop, highlighting will fallback to default Vim syntax highlighting
highlight = {
enable = true,
disable = {'org'}, -- Remove this to use TS highlighter for some of the highlights (Experimental)
additional_vim_regex_highlighting = {'org'}, -- Required since TS highlighter doesn't support all syntax features (conceal)
},
ensure_installed = {'org'}, -- Or run :TSUpdate org
}

--]]

-- Launch panel if nothing is typed after <leader>z
vim.keymap.set("n", "<leader>z", "<cmd>Telekasten panel<CR>")

-- Most used functions
vim.keymap.set("n", "<leader>zf", "<cmd>Telekasten find_notes<CR>")
vim.keymap.set("n", "<leader>zg", "<cmd>Telekasten search_notes<CR>")
vim.keymap.set("n", "<leader>zd", "<cmd>Telekasten goto_today<CR>")
vim.keymap.set("n", "<leader>zz", "<cmd>Telekasten follow_link<CR>")
vim.keymap.set("n", "<leader>zn", "<cmd>Telekasten new_note<CR>")
vim.keymap.set("n", "<leader>zc", "<cmd>Telekasten show_calendar<CR>")
vim.keymap.set("n", "<leader>zb", "<cmd>Telekasten show_backlinks<CR>")
vim.keymap.set("n", "<leader>zI", "<cmd>Telekasten insert_img_link<CR>")

-- Call insert link automatically when we start typing a link
vim.keymap.set("i", "[[", "<cmd>Telekasten insert_link<CR>")

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim
vim.schedule(function() vim.opt.clipboard = 'unnamedplus' end)

-- Move Past
-- ---------
vim.o.scrolloff = 1
vim.o.sidescrolloff = 1

-- Shifting Text
-- -------------
vim.opt.shiftwidth = 4 -- Number of spaces text is shifted with > or <
vim.opt.shiftround = true -- When shifting text with > or < round to the nearest multiple of shiftwidth

-- Tabs
-- ----
vim.opt.expandtab = true -- Inserts spaces instead of tabs.
vim.opt.softtabstop = 4 -- Number spaces tab is equal to while in insert mode.
vim.opt.smarttab = true -- Always use topstop or softtabstop when inserting text.
vim.opt.tabstop = 4 -- Number spaces a tab is equal to.

-- Visual Cues
-- ===========
-- Make line numbers default
vim.wo.number = true -- Show Line Numbers
vim.wo.cursorline = true -- Underline the line the cursor's on
vim.opt.list = true -- Highlights blank space - may lead to madness
-- vim.opt.listchars=tab:▸,eol:¬,extends:❯,precedes:❮,trail:·
-- set nostartofline               " Cursor keeps it's position
vim.opt.ruler = true -- Show Cursor position
-- vim.opt.showbreak=↪         -- For line wraps
-- set showcmd               " Show info about the current command - e.g., shows the number of lines selected in visual mode
vim.opt.showmatch = true -- Show matching braces
-- " Highlight lines longer than 130 characters long
-- highlight ColorColumn ctermbg=magenta
-- call matchadd('ColorColumn', '\%131v', 100)

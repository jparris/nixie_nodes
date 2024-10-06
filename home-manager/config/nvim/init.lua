-- Set up the leader key before initializing plugins
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

require("parrisj")

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
        opts = {
            options = {
                component_separators = {left = '', right = ''},
                section_separators = {left = '', right = ''},
                icons_enabled = true,
                theme = 'catppuccin-macchiato'
            }
        }
    }, -- beter-escap used for j-k escape 
    {
        "max397574/better-escape.nvim",
        config = function() require("better_escape").setup() end
    }, { -- telekasten
        'renerocksai/telekasten.nvim',
        dependencies = {
            'nvim-telekasten/calendar-vim', 'nvim-telescope/telescope.nvim'
        },
        config = function()
            require("telekasten").setup({home = vim.fn.expand("~/notes")})
        end
    }, {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope-media-files.nvim'
        },
        config = function()
            require("telescope").load_extension('media_files')
        end
    }, -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            local configs = require("nvim-treesitter.configs")

            configs.setup({
                ensure_installed = {"c", "lua", "vim", "vimdoc", "rust"},
                async_install = false,
                highlight = {enable = true},
                indent = {enable = true}
            })
        end
    }, {'mrjones2014/smart-splits.nvim'}
})

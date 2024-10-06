return { -- telekasten
    'renerocksai/telekasten.nvim',
    dependencies = {
        'nvim-telekasten/calendar-vim',
        'nvim-telescope/telescope.nvim'
    },
    config = function()
        require("telekasten").setup({home = vim.fn.expand("~/notes")})
    end
}

return {
    'nvim-telescope/telescope.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        --'nvim-lua/popup.nvim',
        --'nvim-telescope/telescope-media-files.nvim'
    },
    config = function()
        require("telescope").setup({})
        -- load_extension('media_files')
    end
}

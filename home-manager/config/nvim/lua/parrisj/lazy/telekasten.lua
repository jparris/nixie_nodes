return { -- telekasten
    "renerocksai/telekasten.nvim",
    dependencies = {
        "nvim-telekasten/calendar-vim",
        "nvim-telescope/telescope.nvim",
    },
    config = function()
        require("telekasten").setup({
            vim.keymap.set("n", "<leader>zw", "<cmd>Telekasten goto_thisweek<CR>"),

            home = vim.fn.expand("~/notes/ddn/"),
            dailies = vim.fn.expand("~/notes/ddn/journal"),
            weeklies = vim.fn.expand("~/notes/ddn/journal"),

            filename_space_subst = "_",

            journal_auto_open = true,

            dailies_create_nonexisting = true,
            follow_creates_nonexisting = true,
            weeklies_create_nonexisting = true,

            vaults = {
                personal = {
                    home = vim.fn.expand("~/notes/personal/"),
                    dailies = vim.fn.expand("~/notes/personal/journal"),
                    weeklies = vim.fn.expand("~/notes/personal/journal"),
                },
            },
        })
    end,
}

return {
    "letieu/wezterm-move.nvim",
    keys = { -- Lazy loading, don't need call setup() function
        {"<A-h>", function() require("wezterm-move").move "h" end},
        {"<A-j>", function() require("wezterm-move").move "j" end},
        {"<A-k>", function() require("wezterm-move").move "k" end},
        {"<A-l>", function() require("wezterm-move").move "l" end}
    }
}

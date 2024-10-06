-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim
-- vim.schedule(function() vim.opt.clipboard = 'unnamedplus' end)

-- Cursor
-- ---------
vim.opt.virtualedit = "onemore" -- Allows the cursor to move past the end of line by one space

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

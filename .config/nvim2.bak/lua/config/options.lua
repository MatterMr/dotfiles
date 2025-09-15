vim.opt.guicursor = ""

vim.opt.number = true
vim.opt.relativenumber = true

-- tabs & indentation
vim.opt.tabstop = 4    -- number of visual spaces per TAB
vim.opt.shiftwidth = 4 -- insert 2  spaces on a tab
vim.opt.expandtab = true
vim.autoindent = true
vim.opt.wrap = false

-- search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.cursorline = true
vim.opt.termguicolors = true

vim.opt.swapfile = false
vim.opt.clipboard:append("unnamedplus")

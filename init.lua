vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.g.is_windows = vim.fn.has("win32") == 1
-- Root folder scanned by the project picker (<leader>pp)
vim.g.projects_dir = vim.fn.expand("~/Projects/Code")

require("config.options")
require("config.lazy")
require("config.keymaps")
require("config.autocmds")

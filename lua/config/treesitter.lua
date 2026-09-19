require("nvim-treesitter").setup({})

-- Install parsers async; use :TSInstall <lang> to add more
require("nvim-treesitter.install").install({ "lua", "vim", "vimdoc" })

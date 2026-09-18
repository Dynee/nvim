require("config.lazy")

-- General Configuration
vim.opt.number = true -- Line numbers

-- Formatting
require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    -- Conform will run multiple formatters sequentially
    python = { "isort", "black" },
    -- You can customize some of the format options for the filetype (:help conform.format)
    rust = { "rustfmt", lsp_format = "fallback" },
    -- Conform will run the first available formatter
    javascript = { "prettierd", "prettier", stop_after_first = true },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_format = "fallback",
  },
})

-- Treesitter
local languages = {
  "awk",
  "bash",
  "c",
  "cmake",
  "c_sharp",
  "cpp",
  "csv",
  "java",
  "json",
  "gitignore",
  "go",
  "html",
  "lua",
  "make",
  "nginx",
  "php",
  "perl",
  "python",
  "ruby",
}

vim.lsp.config("nvim-treesitter", {
  ensure_installed = languages,
  highlight = { enable = true },
  indent = { enable = true },
})
vim.lsp.enable("nvim-treesitter")

-- Telescope
local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })

-- Colorscheme
require("gruvbox").setup({})
vim.cmd.colorscheme("gruvbox")

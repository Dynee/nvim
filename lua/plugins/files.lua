return {
  -- Edit directories like buffers (see :h oil). "-" opens the parent directory.
  {
    "stevearc/oil.nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = { { "-", "<cmd>Oil<cr>", desc = "Open parent directory" } },
    opts = { default_file_explorer = true },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
    keys = { { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "File tree" } },
    opts = { filesystem = { hijack_netrw_behavior = "disabled", follow_current_file = { enabled = true } } },
  },
}

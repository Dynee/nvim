return {
  {
    "marko-cerovac/material.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.material_style = "palenight"
      require("material").setup({
        plugins = { "neo-tree", "nvim-web-devicons", "telescope", "which-key", "rainbow-delimiters", "neogit", "dap", "gitsigns" },
      })
      vim.cmd.colorscheme("material")
    end,
  },

  { "nvim-tree/nvim-web-devicons", lazy = true },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = { theme = "auto", globalstatus = true, component_separators = "", section_separators = "" },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff" },
        lualine_c = { { "filename", path = 1 }, "diagnostics" },
        lualine_x = { "lsp_status", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      spec = {
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code" },
        { "<leader>d", group = "debug" },
        { "<leader>f", group = "find" },
        { "<leader>g", group = "git" },
        { "<leader>p", group = "project" },
        { "<leader>u", group = "toggle" },
        { "gr", group = "lsp" },
      },
    },
  },

  { "HiPhish/rainbow-delimiters.nvim", event = "BufReadPost" },

  -- Breadcrumbs in the winbar
  { "Bekaboo/dropbar.nvim", event = "BufReadPost" },
}

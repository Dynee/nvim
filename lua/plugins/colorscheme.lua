return {
  { "ellisonleao/gruvbox.nvim" },
  {
    "maxmx03/solarized.nvim",
    config = function()
      vim.o.background = "dark"
      require("solarized").setup({})
      vim.cmd.colorscheme("solarized")
    end,
  },
}

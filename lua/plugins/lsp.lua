return {
  {
    "neovim/nvim-lspconfig",
    dependencies = { "folke/lazydev.nvim" },
    config = function()
      require("config.lsp")
    end,
  },
  { "folke/lazydev.nvim" },
}

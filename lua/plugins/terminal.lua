return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = { { [[<C-\>]], desc = "Toggle terminal" } },
    cmd = "ToggleTerm",
    opts = { open_mapping = [[<C-\>]], direction = "horizontal", size = 15 },
  },
}

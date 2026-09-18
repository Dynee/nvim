# neovim

This project is my own configuration for neovim. If you wish to use this configuration clone the project and run the following
command.

```sh
git clone https://github.com/Dynee/nvim ~/.config/nvim
```

## Package Management

This project uses [lazy](https://lazy.folke.io/) for managing packages.

To add a new plugin simply add a lua file in `~/.config/nvim/lua/plugins/<plugin>.lua` and

update `~/.config/nvim/init.lua` with your required configuration.

### Example configuration

This example shows how to configure `conform.nvim` an autoformatter for neovim.

Add the plugin to `~/.config/nvim/lua/plugins/conform.lua`

```lua
return {
  {
    "stevearc/conform.nvim",
    opts = {},
  },
}
```

Update `init.lua` with your configuration.

```lua
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

```



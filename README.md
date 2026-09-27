# neovim

My personal Neovim configuration. To use it, clone the repo into the Neovim config directory:

```sh
git clone https://github.com/Dynee/nvim ~/.config/nvim
```

Requires Neovim 0.12+.

## Structure

```
~/.config/nvim/
├── init.lua              # Entry point: options and keymaps
└── lua/
    ├── config/
    │   ├── pack.lua          # lazy.nvim bootstrap
    │   ├── lsp.lua           # LSP server configuration
    │   ├── cmp.lua           # Completion setup
    │   └── treesitter.lua    # Treesitter configuration
    └── plugins/
        ├── colorscheme.lua   # gruvbox + solarized
        ├── conform.lua       # Formatting
        ├── cmp.lua           # Completion engine and sources
        ├── gitsigns.lua      # Git hunk indicators and blame
        ├── lsp.lua           # LSP plugins
        ├── lualine.lua       # Statusline
        ├── telescope.lua     # Fuzzy finder
        ├── treesitter.lua    # Syntax highlighting
        ├── trouble.lua       # Diagnostics list
        ├── typescript-tools.lua # TypeScript LSP
        └── which-key.lua     # Keymap hints
```

## Package Management

This config uses [lazy.nvim](https://github.com/folke/lazy.nvim). On first launch it auto-installs itself and all plugins — no restart needed.

Each plugin has its own spec file under `lua/plugins/`. To add a new plugin, create a file there returning a lazy.nvim spec table:

```lua
return {
  {
    "author/plugin-name",
    config = function()
      require("plugin-name").setup({})
    end,
  },
}
```

Run `:Lazy` to open the plugin manager UI.

## Plugins

| Plugin | Purpose |
|---|---|
| [gruvbox.nvim](https://github.com/ellisonleao/gruvbox.nvim) | Colorscheme |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | Statusline |
| [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) | File icons |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git hunk indicators and blame |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP server configurations |
| [lazydev.nvim](https://github.com/folke/lazydev.nvim) | Lua/Neovim API completion |
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) | Completion engine |
| [cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp) | LSP completion source |
| [cmp-buffer](https://github.com/hrsh7th/cmp-buffer) | Buffer completion source |
| [cmp-path](https://github.com/hrsh7th/cmp-path) | Path completion source |
| [cmp-cmdline](https://github.com/hrsh7th/cmp-cmdline) | Cmdline completion source |
| [LuaSnip](https://github.com/L3MON4D3/LuaSnip) | Snippet engine |
| [cmp_luasnip](https://github.com/saadparwaiz1/cmp_luasnip) | Snippet completion source |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlighting and parsing |
| [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) | Lua utility library |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder |
| [telescope-fzf-native.nvim](https://github.com/nvim-telescope/telescope-fzf-native.nvim) | FZF sorter for Telescope |
| [conform.nvim](https://github.com/stevearc/conform.nvim) | Formatting |
| [trouble.nvim](https://github.com/folke/trouble.nvim) | Diagnostics list |
| [which-key.nvim](https://github.com/folke/which-key.nvim) | Keymap hints |
| [typescript-tools.nvim](https://github.com/pmizio/typescript-tools.nvim) | TypeScript LSP |
| [solarized.nvim](https://github.com/maxmx03/solarized.nvim) | Colorscheme |

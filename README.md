# neovim

My personal Neovim configuration. To use it, clone the repo into the Neovim config directory:

```sh
git clone https://github.com/Dynee/nvim ~/.config/nvim
```

Requires Neovim 0.12+.

## Structure

```
~/.config/nvim/
├── init.lua              # Entry point: options, keymaps, plugin setup
└── lua/config/
    ├── pack.lua          # Package declarations (vim.pack)
    ├── lsp.lua           # LSP server configuration
    ├── cmp.lua           # Completion setup
    └── treesitter.lua    # Treesitter configuration
```

## Package Management

This config uses `vim.pack`, Neovim 0.12's built-in package manager. All packages are declared in `lua/config/pack.lua`:

```lua
vim.pack.add({
  "https://github.com/some/plugin",
  { src = "https://github.com/some/plugin-with-build", build = ":SomeCommand" },
}, { confirm = false })
```

On first launch, packages download in the background — restart Neovim once the install completes before plugin setup runs.

To add a new plugin, add its URL to the `vim.pack.add` call in `lua/config/pack.lua`, then configure it in `init.lua`.

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

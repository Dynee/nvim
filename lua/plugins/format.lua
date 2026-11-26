-- Formatting via conform.nvim; falls back to the language server (rust-analyzer → rustfmt,
-- jdtls, ruby-lsp → rubocop, intelephense, etc.) when no formatter is listed.
-- Project-local tools (node_modules/.bin/prettier, etc.) are preferred automatically.
local web = { "prettier" }

return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    keys = {
      { "<leader>cf", function() require("conform").format({ async = true }) end, mode = { "n", "x" }, desc = "Format" },
      { "<leader>uf", function()
          vim.g.disable_autoformat = not vim.g.disable_autoformat
          vim.notify("Format on save " .. (vim.g.disable_autoformat and "off" or "on"))
        end, desc = "Toggle format on save" },
    },
    opts = {
      default_format_opts = { lsp_format = "fallback" },
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_organize_imports", "ruff_format" },
        go = { "goimports", "gofmt" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        cs = { "csharpier" },
        javascript = web, javascriptreact = web, typescript = web, typescriptreact = web,
        vue = web, svelte = web, html = web, htmlangular = web, css = web, scss = web,
        json = web, jsonc = web, yaml = web, markdown = web,
        terraform = { "terraform_fmt" }, ["terraform-vars"] = { "terraform_fmt" },
        -- php, ruby, java, rust: language server formatting (fallback)
      },
      format_on_save = function()
        if vim.g.disable_autoformat then return end
        return { timeout_ms = 1000 }
      end,
    },
  },
}

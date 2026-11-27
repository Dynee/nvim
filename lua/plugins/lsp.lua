-- Neovim's built-in LSP. Default maps (see :h lsp-defaults):
--   K hover, grn rename, gra code action, grr references, gri implementation,
--   grt type definition, gO document symbols, <C-s> (insert) signature help
local langs = require("config.languages")

return {
  { "mason-org/mason.nvim", cmd = "Mason", opts = {} },

  -- Installs every server / formatter / debug adapter in config/languages.lua
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",
    dependencies = { "mason-org/mason.nvim" },
    opts = { ensure_installed = langs.mason, run_on_start = true },
    config = function(_, opts)
      require("mason").setup()
      require("mason-tool-installer").setup(opts)
      vim.cmd("MasonToolsInstall")
    end,
  },

  { "b0o/SchemaStore.nvim", lazy = true },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason-org/mason.nvim", "saghen/blink.cmp", "b0o/SchemaStore.nvim" },
    config = function()
      -- Put Mason's bin dir on PATH even before mason.nvim itself loads
      local sep = vim.g.is_windows and ";" or ":"
      local mason_bin = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "bin")
      if not vim.env.PATH:find(mason_bin, 1, true) then
        vim.env.PATH = mason_bin .. sep .. vim.env.PATH
      end

      vim.diagnostic.config({ virtual_text = true, float = { border = "rounded" } })
      vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })

      vim.lsp.config("lua_ls", { settings = { Lua = { diagnostics = { globals = { "vim" } } } } })

      -- Vue: vtsls hosts the Vue TypeScript plugin, vue_ls handles template/style
      vim.lsp.config("vtsls", {
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
        settings = {
          vtsls = {
            tsserver = {
              globalPlugins = {
                {
                  name = "@vue/typescript-plugin",
                  location = vim.fs.joinpath(vim.fn.stdpath("data"),
                    "mason/packages/vue-language-server/node_modules/@vue/language-server"),
                  languages = { "vue" },
                  configNamespace = "typescript",
                },
              },
            },
          },
        },
      })

      -- C#: OmniSharp intermittently sends bare `null` JSON-RPC bodies (right after its
      -- o#/*diagnosticstatus notifications). Neovim 0.12 treats that as INVALID_SERVER_MESSAGE
      -- and kills the client, so drop those bodies for this server only.
      vim.lsp.config("omnisharp", {
        cmd = function(dispatchers, config)
          local rpc = vim.lsp.rpc
          local orig = rpc.create_read_loop
          rpc.create_read_loop = function(handle_body, ...)
            return orig(function(body)
              if body ~= "null" then handle_body(body) end
            end, ...)
          end
          local ok, client = pcall(rpc.start, {
            vim.fn.executable("OmniSharp") == 1 and "OmniSharp" or "omnisharp",
            "-z",
            "--hostPID", tostring(vim.fn.getpid()),
            "DotNet:enablePackageRestore=false",
            "--encoding", "utf-8",
            "--languageserver",
          }, dispatchers, { cwd = config.root_dir })
          rpc.create_read_loop = orig -- read loop is created synchronously inside start()
          if not ok then error(client) end
          return client
        end,
      })

      vim.lsp.config("html", { filetypes = { "html", "htmlangular" } })

      vim.lsp.config("jsonls", {
        settings = { json = { schemas = require("schemastore").json.schemas(), validate = { enable = true } } },
      })
      vim.lsp.config("yamlls", {
        settings = {
          yaml = {
            schemaStore = { enable = false, url = "" }, -- use SchemaStore.nvim instead
            schemas = require("schemastore").yaml.schemas(),
          },
        },
      })

      vim.lsp.enable(langs.servers)

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local tb = require("telescope.builtin")
          local map = function(lhs, rhs, desc) vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, desc = desc }) end
          map("gd", tb.lsp_definitions, "Go to definition")
          map("<leader>cs", tb.lsp_document_symbols, "Document symbols")
          map("<leader>cS", tb.lsp_dynamic_workspace_symbols, "Workspace symbols")
          map("<leader>ch", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }), { bufnr = ev.buf })
          end, "Toggle inlay hints")
        end,
      })
    end,
  },

  {
    "saghen/blink.cmp",
    version = "1.*",
    event = "InsertEnter",
    opts = {
      keymap = { preset = "default" }, -- <C-y> accept, <C-n>/<C-p> select, <C-space> open
      completion = { documentation = { auto_show = true, auto_show_delay_ms = 200 } },
      signature = { enabled = true },
      sources = { default = { "lsp", "path", "snippets", "buffer" } },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      -- Building parsers needs the tree-sitter CLI and a C compiler (see README).
      -- Without them, Neovim's bundled parsers (lua, vim, vimdoc, markdown, c, query) still work.
      if vim.fn.executable("tree-sitter") == 1 then
        require("nvim-treesitter").install(langs.parsers)
      end
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(ev)
          if pcall(vim.treesitter.start, ev.buf) then
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
}

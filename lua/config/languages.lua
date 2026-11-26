-- Single source of truth for language support.
-- Servers/tools whose toolchain isn't on PATH are skipped, so a machine without
-- (say) Java or .NET starts cleanly instead of failing Mason installs on every launch.
local function have(cmd) return vim.fn.executable(cmd) == 1 end

local M = {}

-- { lspconfig name, mason package (false = provided by the toolchain), condition }
local servers = {
  { "clangd", "clangd" },                                       -- C / C++
  { "pyright", "pyright" },                                     -- Python
  { "ruff", "ruff", have("python3") or have("python") },        -- Python lint/format
  { "gopls", "gopls", have("go") },                             -- Go
  { "omnisharp", "omnisharp", have("dotnet") },                 -- C#
  { "vtsls", "vtsls" },                                         -- TS / JS / React (+ Vue via plugin)
  { "eslint", "eslint-lsp" },                                   -- JS/TS linting
  { "svelte", "svelte-language-server" },                       -- Svelte
  { "angularls", "angular-language-server" },                   -- Angular (needs angular.json)
  { "vue_ls", "vue-language-server" },                          -- Vue
  { "intelephense", "intelephense" },                           -- PHP
  -- Ruby: needs Ruby 3+; macOS's built-in /usr/bin/ruby (2.6) can't install ruby-lsp
  { "ruby_lsp", "ruby-lsp", have("gem") and vim.fn.exepath("ruby") ~= "/usr/bin/ruby" },
  { "jdtls", "jdtls", have("java") },                           -- Java (JDK 21+)
  -- Rust: prefer rustup's rust-analyzer (matches your toolchain); Mason's only without rustup
  { "rust_analyzer", not have("rustup") and "rust-analyzer", have("cargo") },
  { "yamlls", "yaml-language-server" },                         -- YAML
  { "jsonls", "json-lsp" },                                     -- JSON
  { "terraformls", "terraform-ls" },                            -- Terraform
  { "tflint", "tflint" },                                       -- Terraform lint
  { "html", "html-lsp" },                                       -- HTML (Angular templates)
  { "cssls", "css-lsp" },                                       -- CSS / SCSS
  { "lua_ls", "lua-language-server" },                          -- Lua (this config)
}

-- { mason package, condition }
local tools = {
  -- formatters
  { "prettier" },
  { "stylua" },
  { "clang-format" },
  { "goimports", have("go") },
  { "csharpier", have("dotnet") },
  -- debug adapters
  { "debugpy", have("python3") or have("python") },
  { "js-debug-adapter" },
  { "codelldb" },                     -- C / C++ / Rust
  { "delve", have("go") },            -- Go
  { "netcoredbg", have("dotnet") },   -- C#
}

M.servers, M.mason = {}, {}
for _, s in ipairs(servers) do
  if s[3] ~= false then
    table.insert(M.servers, s[1])
    if s[2] then table.insert(M.mason, s[2]) end
  end
end
for _, t in ipairs(tools) do
  if t[2] ~= false then table.insert(M.mason, t[1]) end
end

M.parsers = {
  "c", "cpp", "python", "go", "gomod", "gosum", "gowork", "c_sharp",
  "javascript", "typescript", "tsx", "jsdoc", "svelte", "angular", "vue",
  "php", "phpdoc", "ruby", "java", "rust", "yaml", "json", "json5", "terraform", "hcl",
  "html", "css", "scss", "toml", "bash", "regex",
  "lua", "luadoc", "vim", "vimdoc", "markdown", "markdown_inline", "query",
}

return M

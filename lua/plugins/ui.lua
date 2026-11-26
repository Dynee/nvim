return {
  {
    -- Full treesitter + LSP semantic-token coverage, so JSX/TSX (components,
    -- props, tag delimiters, types) gets distinct colors. Styles: night | moon | storm
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "moon",
        -- Let Ghostty's background-opacity (0.9, same as Emacs) show through
        transparent = true,
        styles = {
          comments = { italic = true },
          keywords = { italic = true },
          sidebars = "transparent",
          floats = "transparent",
        },
        on_highlights = function(hl, c)
          -- React: make components stand out from plain HTML tags,
          -- and keep </> brackets subtle so the markup reads cleanly
          hl["@tag.builtin.tsx"] = { fg = c.red }
          hl["@tag.tsx"] = { fg = c.blue1 }
          hl["@tag.delimiter.tsx"] = { fg = c.fg_dark }
          hl["@tag.attribute.tsx"] = { fg = c.green1, italic = true }
          hl["@constructor.tsx"] = { fg = c.blue1 }
        end,
      })
      vim.cmd.colorscheme("tokyonight")
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

return {
	{
		-- Full treesitter + LSP semantic-token coverage, so JSX/TSX (components,
		-- props, tag delimiters, types) gets distinct colors. Styles: night | moon | storm
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("tokyonight").setup({
				style = "night",
				-- Let Ghostty's background-opacity (0.9, same as Emacs) show through
				transparent = true,
				styles = {
					comments = { italic = true },
					keywords = { italic = true },
					sidebars = "transparent",
					floats = "transparent",
				},
				-- Recolor to match the CachyOS "cachyos-nord" GTK theme
				-- (/usr/share/themes/cachyos-nord): deep navy + cyan accent.
				on_colors = function(c)
					c.bg = "#0f121c" -- theme_bg_color
					c.bg_dark = "#131621" -- theme_base_color
					c.bg_dark1 = "#0c0e16"
					c.bg_float = "#131621"
					c.bg_sidebar = "#131621"
					c.bg_popup = "#181b28"
					c.bg_statusline = "#181b28" -- dark_bg_color (panels/titlebar)
					c.bg_highlight = "#181b28"
					c.bg_visual = "#1d3a4a" -- cyan mixed into bg
					c.bg_search = "#2a91ba"
					c.border = "#1f2e3d"
					c.border_highlight = "#47add6"
					c.fg = "#c8dbe6"
					c.fg_dark = "#8fb3c6"
					c.fg_float = "#c8dbe6"
					c.fg_gutter = "#2a3445"
					c.comment = "#4f6a80"
					c.dark3 = "#3d4b5e"
					c.dark5 = "#5f7890"
					c.blue = "#47add6" -- the accent (selected_bg)
					c.blue0 = "#147aa3" -- link_color
					c.blue1 = "#5eb7db"
					c.blue2 = "#30a3d1"
					c.blue5 = "#86cbe6"
					c.blue6 = "#b4e0f0"
					c.blue7 = "#1d3a4a"
					c.cyan = "#53b2d9"
					c.teal = "#5fc4b8"
					c.green = "#7ae070" -- success_color
					c.green1 = "#6fd0c4"
					c.green2 = "#2a91ba"
					c.yellow = "#adad70" -- warning_color
					c.orange = "#c99b6d"
					c.magenta = "#ad7aa3" -- error_color
					c.magenta2 = "#c46fae"
					c.purple = "#b383a9"
					c.red = "#d77a8a"
					c.red1 = "#c05a6c"
					c.terminal_black = "#2a3445"
					c.git = { add = "#7ae070", change = "#47add6", delete = "#d77a8a", ignore = "#3d4b5e" }
				end,
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

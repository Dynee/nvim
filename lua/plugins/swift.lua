return {
	-- Swift treesitter grammar
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = { "swift" },
		},
	},

	-- SourceKit-LSP (ships with Swift toolchain, not mason-managed)
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				sourcekit = {
					mason = false,
					filetypes = { "swift", "objective-c", "objective-cpp" },
					root_dir = function(bufnr)
						local filename = vim.api.nvim_buf_get_name(bufnr)
						local util = require("lspconfig.util")
						return util.root_pattern("buildServer.json")(filename)
							or util.root_pattern("*.xcodeproj", "*.xcworkspace")(filename)
							or util.find_git_ancestor(filename)
							or util.root_pattern("Package.swift")(filename)
					end,
				},
			},
		},
	},

	-- Swift debugging via lldb-dap bundled with the Swift toolchain.
	-- IMPORTANT: use xcrun to find lldb-dap — standalone LLVM builds lack Swift support.
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
		},
		keys = {
			{ "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
			{ "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end, desc = "Conditional Breakpoint" },
			{ "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
			{ "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
			{ "<leader>do", function() require("dap").step_over() end, desc = "Step Over" },
			{ "<leader>dO", function() require("dap").step_out() end, desc = "Step Out" },
			{ "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
			{ "<leader>du", function() require("dapui").toggle() end, desc = "Toggle DAP UI" },
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			dapui.setup()
			dap.listeners.before.attach.dapui_config = function() dapui.open() end
			dap.listeners.before.launch.dapui_config = function() dapui.open() end
			dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
			dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

			local lldb_dap = vim.fn.trim(vim.fn.system("xcrun --find lldb-dap 2>/dev/null"))
			if vim.v.shell_error ~= 0 or lldb_dap == "" then
				lldb_dap = vim.fn.trim(vim.fn.system("which lldb-dap 2>/dev/null"))
			end
			if lldb_dap == "" then
				vim.notify("lldb-dap not found; Swift debugging unavailable", vim.log.levels.WARN)
				return
			end

			dap.adapters.swift = {
				type = "executable",
				command = lldb_dap,
			}
			dap.configurations.swift = {
				{
					name = "Launch Swift program",
					type = "swift",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
				},
			}
		end,
	},
}

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
      "mfussenegger/nvim-dap-python",
      { "jay-babu/mason-nvim-dap.nvim", dependencies = { "mason-org/mason.nvim" } },
    },
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "Debug: continue" },
      { "<F10>", function() require("dap").step_over() end, desc = "Debug: step over" },
      { "<F11>", function() require("dap").step_into() end, desc = "Debug: step into" },
      { "<F12>", function() require("dap").step_out() end, desc = "Debug: step out" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Start / continue" },
      { "<leader>dr", function() require("dap").restart() end, desc = "Restart" },
      { "<leader>dq", function() require("dap").terminate() end, desc = "Terminate" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle UI" },
    },
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup()
      dap.listeners.after.event_initialized["dapui"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui"] = function() dapui.close() end

      -- Adapters are installed by mason-tool-installer (config/languages.lua).
      -- This wires up codelldb (C/C++/Rust), delve (Go) and netcoredbg (C#) with default launch configs.
      require("mason-nvim-dap").setup({
        handlers = {
          function(config) require("mason-nvim-dap").default_setup(config) end,
          python = function() end, -- handled by nvim-dap-python below
          js = function() end,     -- handled by the pwa-node adapter below
        },
      })

      local mason = vim.fn.stdpath("data") .. "/mason/packages/"
      local debugpy = mason .. "debugpy/venv/" .. (vim.g.is_windows and "Scripts/python.exe" or "bin/python")
      require("dap-python").setup(vim.fn.executable(debugpy) == 1 and debugpy
        or (vim.g.is_windows and "python" or "python3"))

      dap.adapters["pwa-node"] = {
        type = "server", host = "localhost", port = "${port}",
        executable = {
          command = "node",
          args = { mason .. "js-debug-adapter/js-debug/src/dapDebugServer.js", "${port}" },
        },
      }
      for _, ft in ipairs({ "javascript", "typescript" }) do
        dap.configurations[ft] = {
          { type = "pwa-node", request = "launch", name = "Launch file", program = "${file}", cwd = "${workspaceFolder}" },
          { type = "pwa-node", request = "attach", name = "Attach", processId = require("dap.utils").pick_process, cwd = "${workspaceFolder}" },
        }
      end
    end,
  },
}

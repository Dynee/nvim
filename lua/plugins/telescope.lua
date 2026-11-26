local function project_root()
  return vim.fs.root(0, ".git") or vim.uv.cwd()
end

-- Pick a folder under vim.g.projects_dir, cd into it and open it in oil
local function switch_project()
  local root, dirs = vim.g.projects_dir, {}
  if vim.fn.isdirectory(root) == 1 then
    for name, type in vim.fs.dir(root) do
      if type == "directory" then table.insert(dirs, vim.fs.joinpath(root, name)) end
    end
  end
  vim.ui.select(dirs, {
    prompt = "Switch project",
    format_item = function(p) return vim.fs.basename(p) end,
  }, function(choice)
    if choice then
      vim.cmd.cd(choice)
      require("oil").open(choice)
    end
  end)
end

local builtin = function(name, opts)
  return function() require("telescope.builtin")[name](opts and opts() or nil) end
end

return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = vim.g.is_windows
            and "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release --target install"
          or "make",
        cond = vim.fn.executable(vim.g.is_windows and "cmake" or "make") == 1,
      },
      "nvim-telescope/telescope-ui-select.nvim",
    },
    keys = {
      { "<leader><space>", builtin("find_files"), desc = "Find files" },
      { "<leader>ff", builtin("find_files"), desc = "Find files" },
      { "<leader>fg", builtin("live_grep"), desc = "Grep" },
      { "<leader>fw", builtin("grep_string"), desc = "Grep word under cursor" },
      { "<leader>fb", builtin("buffers"), desc = "Buffers" },
      { "<leader>fr", builtin("oldfiles"), desc = "Recent files" },
      { "<leader>fh", builtin("help_tags"), desc = "Help" },
      { "<leader>fk", builtin("keymaps"), desc = "Keymaps" },
      { "<leader>fd", builtin("diagnostics"), desc = "Diagnostics" },
      { "<leader>ft", builtin("colorscheme", function() return { enable_preview = true } end), desc = "Themes" },
      { "<leader>f/", builtin("current_buffer_fuzzy_find"), desc = "Search buffer" },
      { "<leader>fR", builtin("resume"), desc = "Resume last picker" },
      { "<leader>pp", switch_project, desc = "Switch project" },
      { "<leader>pf", builtin("find_files", function() return { cwd = project_root() } end), desc = "Find file in project" },
      { "<leader>pg", builtin("live_grep", function() return { cwd = project_root() } end), desc = "Grep project" },
    },
    config = function()
      local actions = require("telescope.actions")
      require("telescope").setup({
        defaults = {
          sorting_strategy = "ascending",
          layout_config = { prompt_position = "top" },
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
            },
          },
        },
        pickers = {
          buffers = { mappings = { i = { ["<C-d>"] = actions.delete_buffer } } },
        },
      })
      pcall(require("telescope").load_extension, "fzf") -- falls back to the Lua sorter if not built
      require("telescope").load_extension("ui-select")
    end,
  },
}

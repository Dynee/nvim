-- Suppress clangd diagnostics when no compilation database is present.
-- Without compile_commands.json, clangd floods foreign code (e.g. glibc) with
-- false errors about missing Linux headers and undefined GNU-specific types.
-- Navigation and completion still work; diagnostics return once you add
-- compile_commands.json, compile_flags.txt, or a .clangd file to the project.
return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				clangd = {
					handlers = {
						["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
							if result and result.diagnostics then
								local client = vim.lsp.get_client_by_id(ctx.client_id)
								local root = client and client.config.root_dir
								if root then
									local has_db = vim.fn.filereadable(root .. "/compile_commands.json") == 1
										or vim.fn.filereadable(root .. "/build/compile_commands.json") == 1
										or vim.fn.filereadable(root .. "/compile_flags.txt") == 1
										or vim.fn.filereadable(root .. "/.clangd") == 1
									if not has_db then
										result.diagnostics = {}
									end
								end
							end
							vim.lsp.handlers["textDocument/publishDiagnostics"](err, result, ctx, config)
						end,
					},
				},
			},
		},
	},
}

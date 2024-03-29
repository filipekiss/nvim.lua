return {

	-- add typescript to treesitter
	{
		"nvim-treesitter",
		opts = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				vim.list_extend(opts.ensure_installed, { "typescript", "tsx" })
			end
		end,
	},

	-- correctly setup lspconfig
	{
		"nvim-lspconfig",
		dependencies = {
			"https://github.com/jose-elias-alvarez/typescript.nvim",
		},
		opts = {
			servers = {
				tsserver = {
					settings = {
						completions = {
							completeFunctionCalls = true,
						},
					},
				},
			},
			setup = {
				tsserver = function(_, opts)
					Idle.load("functions.lsp").attach_autocmd(
						function(client, buffer)
							if client.name == "tsserver" then
								vim.keymap.set("n", "<leader>co", function()
									local ts = require("typescript")
									ts.actions.removeUnused({ sync = true })
									ts.actions.organizeImports({ sync = true })
								end, {
									buffer = buffer,
									desc = "Organize Imports",
								})
              -- stylua: ignore
              vim.keymap.set("n", "<leader>cR", "<cmd>TypescriptRenameFile<CR>", { desc = "Rename File", buffer = buffer })
							end
						end
					)
					require("typescript").setup({ server = opts })
					return true
				end,
			},
		},
	},
	{
		"null-ls.nvim",
		opts = function(_, opts)
			table.insert(
				opts.sources or {},
				require("typescript.extensions.null-ls.code-actions")
			)
		end,
	},
}

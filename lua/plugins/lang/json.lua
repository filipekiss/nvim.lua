return {

	-- add json to treesitter
	{
		"nvim-treesitter",
		opts = function(_, opts)
			opts.ensure_installed = vim.list_extend(
				opts.ensure_installed or {},
				{ "json", "json5", "jsonc" }
			)
		end,
	},

	-- correctly setup lspconfig
	{
		"nvim-lspconfig",
		dependencies = {
			"https://github.com/b0o/SchemaStore.nvim",
			version = false, -- last release is way too old
		},
		opts = {
			-- make sure mason installs the server
			servers = {
				jsonls = {
					-- lazy-load schemastore when needed
					on_new_config = function(new_config)
						new_config.settings.json.schemas = new_config.settings.json.schemas
							or {}
						vim.list_extend(
							new_config.settings.json.schemas,
							require("schemastore").json.schemas()
						)
					end,
					settings = {
						json = {
							format = {
								enable = true,
							},
							validate = { enable = true },
						},
					},
				},
			},
		},
	},
}

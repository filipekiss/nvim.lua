local function organize_imports()
	local params = {
		command = "_typescript.organizeImports",
		arguments = { vim.api.nvim_buf_get_name(0) },
		title = "",
	}
	vim.lsp.buf.execute_command(params)
end

local tsserver = {
	on_attach = function(client)
		-- disable tsserver formatting, I'll use prettier with null-ls
		client.server_capabilities.documentFormattingProvider = false
	end,
	init_options = {
		preferences = {
			importModuleSpecifierPreference = "project-relative",
		},
	},
	commands = {
		OrganizeImports = {
			organize_imports,
			description = "Organize Imports",
		},
	},
}

return tsserver

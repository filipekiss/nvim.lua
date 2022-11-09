-- https://github.com/sumneko/lua-language-server
local sumneko = {
	on_attach = function(client)
		-- disabled so I can use stylua
		client.resolved_capabilities.document_formatting = false
	end,
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim", "s", "f", "d", "t", "i", "sn" },
			},
			workspace = {
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
				},
			},
		},
	},
}

return sumneko

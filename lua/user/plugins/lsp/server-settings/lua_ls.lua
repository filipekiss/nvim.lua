-- https://github.com/sumneko/lua-language-server
local lua_ls = {
	on_attach = function(client)
		-- disabled so I can use stylua
		client.server_capabilities.documentFormattingProvider = false
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

return lua_ls

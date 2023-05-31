return {
	"https://github.com/L3MON4D3/LuaSnip",
	lazy = true,
	build = (not jit.os:find("Windows")) and "make install_jsregexp" or nil,
	dependencies = {
		"https://github.com/rafamadriz/friendly-snippets",
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load()
			require("luasnip.loaders.from_lua").lazy_load({
				paths = "./lua/user/snippets",
			})
		end,
	},
	opts = {
		history = true,
		delete_check_events = "TextChanged",
	},
	-- stylua: ignore
	keys = {
		{
			"<c-s>",
			function()
				return require("luasnip").expandable()
						and "<Plug>luasnip-expand-snippet"
					or "<c-s>"
			end,
			expr = true,
			silent = true,
			mode = "i",
			desc = "[LuaSnip] Expand Snippet",
		},
		{
			"<c-m>",
			function()
				return require("luasnip").choice_active()
						and "<Plug>luasnip-next-choice"
					or "<c-m>"
			end,
			expr = true,
			silent = true,
			mode = { "i", "s" },
			desc = "[LuaSnip] Next Choice",
		},
	},
}

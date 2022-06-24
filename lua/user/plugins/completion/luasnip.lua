return {
	"https://github.com/L3MON4D3/LuaSnip",
	config = function()
		local safe_require = require("nebula.helpers.require").safe_require
		local luasnip = safe_require("luasnip")
		if not luasnip then
			return
		end
		luasnip.config.setup(Nebula.get_config("luasnip"))
		local vscode_loader = require("luasnip/loaders/from_vscode")
		vscode_loader.lazy_load()
	end,
}

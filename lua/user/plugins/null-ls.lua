local plugin = require("nebula.helpers.plugins").plugin

return {
	"https://github.com/jose-elias-alvarez/null-ls.nvim/",
	config = function()
		local safe_require = require("nebula.helpers.require").safe_require
		local null_ls = safe_require("null-ls")
		if not null_ls then
			return
		end

		null_ls.setup(Nebula.get_config("null-ls"))
	end,
	requires = { plugin("plenary") },
}

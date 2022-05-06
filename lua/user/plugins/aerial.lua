return {
	"https://github.com/stevearc/aerial.nvim",
	config = function()
		local safe_require = require("nebula.helpers.require").safe_require
		local aerial = safe_require("aerial")

		if not aerial then
			return
		end

		aerial.setup(Nebula.get_config("aerial"))
	end,
}

return {
	"https://github.com/goolord/alpha-nvim",
	config = function()
		local safe_require = require("nebula.helpers.require").safe_require
		local alpha = safe_require("alpha")

		if not alpha then
			return
		end

		require("alpha.term")

		alpha.setup(Nebula.get_config("alpha"))
	end,
}

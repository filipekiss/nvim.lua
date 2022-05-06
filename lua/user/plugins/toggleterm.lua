return {
	"https://github.com/akinsho/toggleterm.nvim",
	config = function()
		local safe_require = require("nebula.helpers.require").safe_require
		local toggleterm = safe_require("toggleterm")

		if not toggleterm then
			return
		end

		toggleterm.setup(Nebula.get_config("toggleterm"))
	end,
}

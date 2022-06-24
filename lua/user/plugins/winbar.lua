return {
	"https://github.com/fgheng/winbar.nvim",
	disable = function()
		return vim.fn.has("nvim-0.8.0") == 0
	end,
	config = function()
		local safe_require = require("nebula.helpers.require").safe_require
		local winbar = safe_require("winbar")

		if not winbar then
			return
		end

		winbar.setup(Nebula.get_config("winbar"))
	end,
	requires = {
		"https://github.com/SmiteshP/nvim-gps",
	},
}

return {
	"m-demare/hlargs.nvim",
	requires = { "nvim-treesitter/nvim-treesitter" },
	config = function()
		local safe_require = require("nebula.helpers.require").safe_require
		local hlargs = safe_require("hlargs")

		if not hlargs then
			return
		end

		hlargs.setup()
	end,
}

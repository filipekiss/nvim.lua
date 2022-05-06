return {
	"https://github.com/nvim-treesitter/nvim-treesitter",
	run = ":TSUpdate",
	config = function()
		local safe_require = require("nebula.helpers.require").safe_require
		local tsconfig = safe_require("nvim-treesitter.configs")

		if not tsconfig then
			return
		end

		tsconfig.setup(Nebula.get_config("treesitter"))
	end,
}

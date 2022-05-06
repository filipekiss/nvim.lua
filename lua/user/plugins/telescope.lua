local plugin = require("nebula.helpers.plugins").plugin

return {
	"https://github.com/nvim-telescope/telescope.nvim",
	requires = { plugin("plenary") },
	config = function()
		local telescope = require("telescope")

		telescope.setup(Nebula.get_config("telescope"))
	end,
}

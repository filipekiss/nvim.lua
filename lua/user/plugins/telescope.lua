local plugin = require("nebula.helpers.plugins").plugin

return {
	"https://github.com/nvim-telescope/telescope.nvim",
	requires = {
		plugin("plenary"),
		"https://github.com/nvim-telescope/telescope-ui-select.nvim",
	},
	config = function()
		local telescope = require("telescope")

		telescope.setup(Nebula.get_config("telescope"))
		telescope.load_extension("ui-select")
	end,
}

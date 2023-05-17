return {
	"https://github.com/ThePrimeagen/harpoon",
	opts = {},
	keys = {
		{
			"gH",
			function()
				local ui = require("harpoon.ui")
				ui.toggle_quick_menu()
			end,
		},
		{
			"gh",
			function()
				if vim.v.count > 0 then
					require("harpoon.ui").nav_file(vim.v.count)
				else
					require("harpoon.mark").toggle_file()
				end
			end,
		},
	},
}

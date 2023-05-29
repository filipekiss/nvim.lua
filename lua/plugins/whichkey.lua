return {
	"https://github.com/folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		plugins = { spelling = true },
		operators = { gc = "Comments" },
		defaults = {
			mode = { "n", "v" },
			["g"] = { name = "+goto" },
			["s"] = { name = "+surround" },
			["]"] = { name = "+next" },
			["["] = { name = "+prev" },
			["<leader>b"] = { name = "+buffer" },
			["<leader>c"] = { name = "+code" },
			["<leader>f"] = { name = "+file/find" },
			["<leader>g"] = { name = "+git" },
			["<leader>gh"] = { name = "+hunks" },
			["<leader>gt"] = { name = "+toggle" },
			["<leader>s"] = { name = "+search" },
			["<leader>x"] = { name = "+diagnostics" },
			["<leader>t"] = { name = "+terminal" },
			["<leader>u"] = { name = "+utils" },
		},
	},
	config = function(_, opts)
		local wk = require("which-key")
		wk.setup(opts)
		wk.register(opts.defaults)
	end,
}

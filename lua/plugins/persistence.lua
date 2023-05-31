local add_to_whichkey = require("user.functions").add_to_whichkey
return {
	"https://github.com/folke/persistence.nvim",
	event = "BufReadPre",
	opts = {
		options = {
			"buffers",
			"curdir",
			"tabpages",
			"winsize",
			"help",
			"globals",
			"skiprtp",
		},
	},
	dependencies = {
		add_to_whichkey("persistence.nvim", {
			["<leader>q"] = { name = "+session" },
		}),
	},
	-- stylua: ignore
	keys = {
		{
			"<leader>qs",
			function()
				require("persistence").load()
			end,
			desc = "Restore Session",
		},
		{
			"<leader>ql",
			function()
				require("persistence").load({ last = true })
			end,
			desc = "Restore Last Session",
		},
		{
			"<leader>qd",
			function()
				require("persistence").stop()
			end,
			desc = "Don't Save Current Session",
		},
	},
}

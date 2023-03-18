return {
	"https://github.com/williamboman/mason.nvim",
	config = function()
		require("user.plugins.mason.setup")()
	end,
}

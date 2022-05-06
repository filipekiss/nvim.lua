return {
	"https://github.com/numToStr/Comment.nvim",
	config = function()
		local comment = require("Comment")

		comment.setup(Nebula.get_config("comment"))
	end,
	requires = {
		"https://github.com/JoosepAlviste/nvim-ts-context-commentstring", -- add support for jsx comment strings
	},
}

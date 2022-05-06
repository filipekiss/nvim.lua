return {
	"https://github.com/folke/todo-comments.nvim",
	config = function()
		local safe_require = require("nebula.helpers.require").safe_require
		local todo = safe_require("todo-comments")

		if not todo then
			return
		end

		todo.setup(Nebula.get_config("todo-comments"))
	end,
}

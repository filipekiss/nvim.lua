return {
	"https://github.com/windwp/nvim-ts-autotag",
	config = function()
		local safe_require = require("nebula.helpers.require").safe_require
		local autotag = safe_require("nvim-ts-autotag")

		if not autotag then
			return
		end

		autotag.setup(Nebula.get_config("autotag"))
	end,
}

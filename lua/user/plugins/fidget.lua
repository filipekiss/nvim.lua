return {
	"https://github.com/j-hui/fidget.nvim",
	config = function()
		local safe_require = require("nebula.helpers.require").safe_require
		local fidget = safe_require("fidget")

		if not fidget then
			return
		end

		fidget.setup()
	end,
}

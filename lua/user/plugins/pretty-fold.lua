return {
	"https://github.com/anuvyklack/pretty-fold.nvim",
	requires = "https://github.com/anuvyklack/nvim-keymap-amend",
	config = function()
		local safe_require = require("nebula.helpers.require").safe_require
		local pretty_fold = safe_require("pretty-fold")
		local pretty_fold_preview = safe_require("pretty-fold.preview")
		if not pretty_fold_preview or not pretty_fold then
			return
		end
		pretty_fold.setup(Nebula.get_config("pretty-fold"))
		pretty_fold_preview.setup()
	end,
}

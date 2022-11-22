return {
	"https://github.com/ray-x/lsp_signature.nvim",
	config = function()
		local safe_require = require("nebula.helpers.require").safe_require
		local lsp_signature = safe_require("lsp_signature")

		lsp_signature.setup(Nebula.get_config("lsp_signature"))
	end,
}

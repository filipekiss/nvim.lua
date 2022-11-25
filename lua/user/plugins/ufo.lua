return {
	"https://github.com/kevinhwang91/nvim-ufo",
	requires = "https://github.com/kevinhwang91/promise-async",
	config = function()
		local safe_require = require("nebula.helpers.require").safe_require
		local ufo = safe_require("ufo")

		if not ufo then
			return
		end

		local nnoremap = require("nebula.helpers.mappings").nnoremap

		nnoremap("zR", ufo.openAllFolds)
		nnoremap("zM", ufo.closeAllFolds)

		ufo.setup({
			provider_selector = function(_, _, _)
				return { "lsp" }
			end,
		})
	end,
}

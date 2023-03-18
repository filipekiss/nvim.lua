local plugin = require("nebula.helpers.plugins").plugin
return {
	"https://github.com/neovim/nvim-lspconfig",
	requires = {
		plugin("mason"),
		plugin("mason.lspconfig"),
	},
	config = function()
		vim.g.lsp_format_on_save = true
	end,
}
